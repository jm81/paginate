module Paginate
  module Helpers
    # Pagination helpers for Merb applications. See Paginate::Helpers::Shared
    # for additional methods
    module Merb
      include Shared
      
      # A quick method for creating pagination links, using a view partial,
      # (layouts/_page_links, by default).
      # Arguments:
      #
      # - +collection+: an enumerable collection with #current_page and
      #   #pages methods.
      # - +partial_name+: location of the partial to use
      # - +padding+: Maximum number of page links before and after current_page.
      def pagination_partial(collection, partial_name = "layout/page_links", padding = 3)
        padding ||= 3
        partial(partial_name, :current_page => collection.current_page, :pages => collection.pages, :padding => padding)
      end
            
      # +page_url+ generates a URL (for page links), given a page number and
      # optionally a path and query string. By default, the path is the path
      # of the current request, and the query_string is also that of the
      # current request. This allows for order and condition related fields
      # in the query string to be used in the page link.
      def page_url(page, path = request.path, q = request.query_string)
        # Remove any current reference to page in the query string
        q.to_s.gsub!(/page=(\d+)(&?)/, '') 
        # Assemble new link
        link = "#{path}?page=#{page}&#{q}"
        link = link[0..-2] if link[-1..-1] == '&' # Strip trailing ampersand
        link
      end      
    end
  end
end
