module Paginate
  
  # .pagination method for DataMapper models.  
  module DM
    DEFAULT_LIMIT = 100
    
    # Implementation of .paginate for DataMapper.
    # (This is loosely based on http://github.com/lholden/dm-is-paginated)
    #
    # To make available to your model:
    # class MyModel
    #   include DataMapper::Resource
    #   extend Paginate::DM
    #   ...
    # end
    # 
    # Accepts same options as DataMapper::Resource.all, plus:
    # - +page+: The desired page number, 1-indexed. Negative numbers represent
    #   page from the last page (with -1) being the last.
    #
    # The +limit+ option should also be specified and represents records per
    # page. Any +offset+ option will be overriden.
    #
    # Returns the records for the given page number, with other options 
    # processed by +all+. In addition, two methods are added to the result:
    # - +pages+: The total number of pages that the given options would produce.
    # - +current_page+: The number of the current page (as actually returned).
    #   This is never a negative number even if given.
    # If the +page+ option is zero, or less than (-1 * pages) or greater than 
    # the total pages, it will be recalculated to return either page 1 or the 
    # last page, respectively.
    #
    # This is not strictly for DataMapper. The class should respond to .all and
    # .count with options similar to DataMapper (offset and limit are a must)
    # For example, this would probably work in an ActiveRecord model.
    def paginate(options = {})
      page = options.delete(:page).to_i
      limit = options[:limit] ? options[:limit].to_i : DEFAULT_LIMIT
      order = options[:order]
      
      # Remove some options before calling +count+ that are not applicable.
      # order and limit are needed later and have been saved above.
      [:offset, :limit, :order].each do |key|
        options.delete(key)
      end
      
      # Determine total number of pages and set offset option.
      pages = (self.count(options).to_f / limit).ceil
      page = (pages + 1 + page) if page < 0 # Negative page
      page = pages if page > pages # page should not be more than total pages
      page = 1 if page < 1 # Minimum is 1 even if 0 records.
      pages = 1 if pages < 1 # Minimum is 1 even if 0 records.
      options[:offset] = ((page - 1) * limit)
      
      # Add limit and order back into options, from above.
      options[:limit] = limit
      options[:order] = order if order
      
      # Call +all+.
      collection = all(options)

      # Create +pages+ and +current_page+ methods for collection, for use by
      # pagination links.
      collection.instance_variable_set(:@pages, pages)
      collection.instance_variable_set(:@current_page, page)
      def collection.pages; @pages; end
      def collection.current_page; @current_page; end
      
      return collection
    end
  end
end
