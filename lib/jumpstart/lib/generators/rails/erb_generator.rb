require "rails/generators"
require "rails/generators/erb/scaffold/scaffold_generator"

module Erb
  module Generators
    class ScaffoldGenerator
      def index_partial
        template "index_partial.html.erb", File.join("app/views", controller_file_path, "_index.html.erb")
      end
    end
  end
end
