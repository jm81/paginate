module Paginate
  
  # .pagination method for Arrays and similar objects.
  module Simple
    
    # Implementation of .paginate for Arrays and similar objects (must respond
    # to +length+ and +[](start_index, length)+.
    #
    # To make available to all Arrays:
    # Array.include(Paginate::Simple)
    # 
    # For a single Array:
    # array.extend(Paginate::Simple)
    # 
    # Accepts two options:
    # - +page+: The desired page number, 1-indexed. Negative numbers represent
    #   page from the last page (with -1) being the last.
    #- +limit+: represents records per page.
    #
    # Returns a slice of the Array with records for the given page number.
    # Two methods are added to the result:
    # - +pages+: The total number of pages that the given options would produce.
    # - +current_page+: The number of the current page (as actually returned).
    #   This is never a negative number even if given.
    # If the +page+ option is zero, or less than (-1 * pages) or greater than 
    # the total pages, it will be recalculated to return either page 1 or the 
    # last page, respectively.
    def paginate(options = {})
      Paginators::Simple.new(self, options).paginate
    end
  end
end
