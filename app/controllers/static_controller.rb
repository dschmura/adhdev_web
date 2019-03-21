class StaticController < ApplicationController
  def index
  end

  def about
  end

  def pricing
    redirect_to root_path, alert: "There are no pricing plans configured." unless Plan.exists?
  end

  def terms
  end

  def privacy
  end
end
