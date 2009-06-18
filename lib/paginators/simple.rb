module Paginate
  module Paginators
    # This is for use by +Array+ and similar objects.
    class Simple
      # full_collection is an +Array+ (or any Object that responds to +length+
      # and +[](start_index, length)+, such as +LazyArray+. #paginate will
      # return the appropriate slice of that Object.
      # options include:
      # - +page+: The desired page (may be negative)
      # - +limit+: Number of items per page.
      # Other options are ignored.
      # See README for more details. (TODO)
      def initialize(full_collection, options = {})
        @full_collection = full_collection
        @options = options
      end
      
      # Perform the pagination. Returns the records for the given page, with
      # singleton methods:
      # - +current_page+: The number of the current page.
      # - +pages+: The total number of pages of records.
      #
      # See the documents for the module that your class extends for more details.
      #
      # Descendents classes should not need to override this method, but rather
      # + get_full_count+ and +get_paginated_collection+ private methods.
      def paginate
        page = @options.delete(:page).to_i
        limit = @options[:limit] ? @options[:limit].to_i : DEFAULT_LIMIT
        order = @options[:order]
        
        # Remove some options before calling +count+ that are not applicable.
        # order and limit are needed later and have been saved above.
        [:offset, :limit, :order].each do |key|
          @options.delete(key)
        end
        
        # Determine total number of pages and set offset option.
        pages = (get_full_count.to_f / limit).ceil
        page = (pages + 1 + page) if page < 0 # Negative page
        page = pages if page > pages # page should not be more than total pages
        page = 1 if page < 1 # Minimum is 1 even if 0 records.
        pages = 1 if pages < 1 # Minimum is 1 even if 0 records.
        @options[:offset] = ((page - 1) * limit)
        
        # Add limit and order back into options, from above.
        @options[:limit] = limit
        @options[:order] = order if order
        
        # Call +all+.
        collection = get_paginated_collection
  
        # Create +pages+ and +current_page+ methods for collection, for use by
        # pagination links.
        collection.instance_variable_set(:@pages, pages)
        collection.instance_variable_set(:@current_page, page)
        def collection.pages; @pages; end
        def collection.current_page; @current_page; end
        
        return collection
      end
      
      private
      
      # Alias for @full_collection because that's what the @full_collection
      # usually is for ORM class
      def model
        @full_collection
      end
      
      # Return the total number of items/records based on the given conditions.
      # This may be overriden by inherited classes.
      def get_full_count
        @full_collection.length
      end
  
      # Return the records for the given page.
      # This may be overriden by inherited classes.
      def get_paginated_collection
        @full_collection[@options[:offset], @options[:limit]]
      end
    end
  end
end