module Paginate
  
  # .pagination method for ActiveRecord models.  
  module AR
    
    # Implementation of .paginate for ActiveRecord.
    #
    # To make available to your model:
    # class MyModel < ActiveRecord::Base
    #   extend Paginate::AR
    #   ...
    # end
    # 
    # Accepts same options as ActiveRecord::Base.all, plus:
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
    def paginate(options = {})
      Paginators::ORM.new(self, options).paginate
    end
  end
end
