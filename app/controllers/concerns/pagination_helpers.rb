module PaginationHelpers
  extend ActiveSupport::Concern

  private
    # collection must be a pagination object
    def meta_attributes(collection)
      {
        current_page:  collection.current_page,
        next_page:     collection.next_page,
        prev_page:     collection.previous_page,
        total_pages:   collection.total_pages,
        total_records: collection.total_entries
      }
    end

    def paginate(collection, options = {})
      require 'will_paginate/array' if collection.is_a?(Array)
      collection.paginate({
        page: params[:page] || options[:page],
        per_page: params[:per_page] || options[:per_page] || WillPaginate.per_page
      })
    end
end
