require "rails/generators"
require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"

module Rails
  module Generators
    class ScaffoldControllerGenerator
      source_paths << File.expand_path("../templates", __FILE__)

      hook_for :jbuilder, type: :boolean, default: true

      def add_to_navigation
        append_to_file "app/views/shared/_left_nav.html.erb" do
          "<%= nav_link_to \"#{plural_name.titleize}\", #{plural_route_name}_path, class: 'nav-link' %>\n"
        end
      end
    end
  end
end
