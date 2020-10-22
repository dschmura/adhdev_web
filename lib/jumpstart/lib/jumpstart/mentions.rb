module Jumpstart
  module Mentions
    extend ActiveSupport::Concern

    class_methods do
      # Searches a rich text content object for attachments matching class
      #
      # For example:
      #   has_mentions :user, rich_text: :body, class: User
      #
      # Defines `user_mentions` and returns all the User objects attached in the ActionText content
      def has_mentions(name, rich_text:, **options)
        klass = options.fetch(:class, User)

        define_method "#{name}_mentions" do
          content = send(rich_text)
          content.body.attachments.filter_map do |attachment|
            attachment.attachable if attachment.attachable.instance_of?(klass)
          end
        end
      end
    end
  end
end
