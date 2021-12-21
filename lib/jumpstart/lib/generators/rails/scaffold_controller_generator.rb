require "rails/generators"
require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"

module Rails
  module Generators
    class ScaffoldControllerGenerator
      hook_for :jbuilder, type: :boolean, default: true

      def add_to_navigation
        append_to_file "app/views/shared/_left_nav.html.erb" do
          "<%= nav_link_to \"#{plural_table_name.titleize}\", #{index_helper(type: :path)}, class: \"nav-link\" %>\n"
        end
      end
    end
  end
end
