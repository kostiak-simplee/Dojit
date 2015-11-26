module Pagination
  extend ActiveSupport::Concern

  module ClassMethods
    def paginate(params)
      page = params[:page].to_i || 1
      @per_page = params[:per_page].to_i || 10
      @pages = (count.to_f / @per_page).ceil
      limit(per_page).offset( (page - 1) * @per_page )
    end

    def per_page
      @per_page
    end

    def pages
      @pages
    end
  end
end