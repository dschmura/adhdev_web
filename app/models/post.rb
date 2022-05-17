# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  post_status :enum             default("draft"), not null
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :posts, partial: "posts/index", locals: { post: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :posts, target: dom_id(self, :index) }

  enum post_status: {
    draft: "draft", published: "published", archived: "archived"
  }, _prefix: true
end
