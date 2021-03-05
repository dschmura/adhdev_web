require "rails/generators"
require "rails/generators/erb/scaffold/scaffold_generator"

module Erb
  module Generators
    class ScaffoldGenerator
      source_paths << File.expand_path("../templates", __FILE__)

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
          "<%= nav_link_to \"#{plural_name.titleize}\", #{plural_route_name}_path, class: 'nav-link' %>\n"
        end
      end
    end
  end
end
