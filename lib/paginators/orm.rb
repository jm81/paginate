module Paginate
  module Paginators
    class ORM < Simple
      private
      
      # Return the total number of records based on the given conditions.
      def get_full_count
        model.count(:id, @options)
      end
  
      # Return the records for the given page.
      def get_paginated_collection
        model.all(@options)
      end
    end
  end
end
