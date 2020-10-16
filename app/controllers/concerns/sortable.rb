module Sortable
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction
  end

  private

  def sort_column(klass)
    klass.sortable_columns.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction(default: "asc")
    ["asc", "desc"].include?(params[:direction]) ? params[:direction] : default
  end
end
