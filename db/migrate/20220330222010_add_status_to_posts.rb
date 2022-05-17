class AddStatusToPosts < ActiveRecord::Migration[7.0]
  # note that enums cannot be dropped [https://blog.saeloun.com/2022/01/12/rails-7-adds-custom-enum-support-in-postgresql.html]
  create_enum :status, ["draft", "published", "archived"]

  change_table :posts do |t|
    t.enum :post_status, enum_type: "status", default: "draft", null: false
  end
end



# https://blog.saeloun.com/2022/01/12/rails-7-adds-custom-enum-support-in-postgresql.html

# <%= form.collection_select :post_status, Post.post_statuses, :status, :post_status %>
