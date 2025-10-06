class SearchController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def index
    @q = params[:q].to_s.strip
    return unless @q.present?

    term = "%#{@q.downcase}%"

    # Adjust model/column names to match your app
    @blogs    = (defined?(Blog)    ? Blog    : nil)&.where("LOWER(title) LIKE ? OR LOWER(body) LIKE ?", term, term) || []
    @products = (defined?(Product) ? Product : nil)&.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ? OR LOWER(content) LIKE ?", term, term, term) || []
    @services = (defined?(Service) ? Service : nil)&.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ? OR LOWER(content) LIKE ?", term, term, term) || []

    # Optional: limits
    @blogs    = @blogs.first(50)
    @products = @products.first(50)
    @services = @services.first(50)
  end
end
