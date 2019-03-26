# frozen_string_literal: true

require "rails/generators/erb"
require "rails/generators/resource_helpers"

module Erb # :nodoc:
  module Generators # :nodoc:
    class ScaffoldGenerator < Base # :nodoc:
      include Rails::Generators::ResourceHelpers

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          formats.each do |format|
            filename = filename_with_extensions(view, format)
            template filename, File.join("app/views", controller_file_path, filename)
          end
        end
      end

      def add_to_navigation
        append_to_file "app/views/shared/_left_nav.html.erb" do
          "<%= nav_link_to \"#{plural_name.titleize}\", #{name.tableize}_path, class: 'nav-link' %>\n"
        end
      end

    private

      def available_views
        %w(index edit show new _form)
      end
    end
  end
end
