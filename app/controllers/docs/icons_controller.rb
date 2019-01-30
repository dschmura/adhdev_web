class Docs::IconsController < ::ApplicationController
  layout "docs"

  def show
    @icons = Dir.chdir(Rails.root.join('app/assets/images')) do
      Dir.glob("icons/*.svg").sort
    end
  end
end