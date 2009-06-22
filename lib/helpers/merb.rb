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
      
      # Returns links for pages, given a +collection+ and optional
      # +padding+ (see Shared#page_set). Returned html will be along the lines
      # of:
      # 
      #    <div class="pageLinks">' +
      #      <span class="pagePrevious"><a href="/list?page=4">&laquo;</a></span>
      #      <span class="pageSpacer">...</span>
      #      <span class="pageNumber"><a href="/list?page=3">3</a></span>
      #      <span class="pageNumber"><a href="/list?page=4">4</a></span>
      #      <span class="pageCurrent">5</span>
      #      <span class="pageNumber"><a href="/list?page=6">6</a></span>
      #      <span class="pageNumber"><a href="/list?page=7">7</a></span>
      #      <span class="pageSpacer">...</span>
      #      <span class="pageNext"><a href="/list?page=6">&raquo;</a></span>
      #    </div>
      #
      # CSS classes are pageSpacer, pageNumber, pageDisabled, pageCurrent, 
      # pagePrevious, and pageNext. pageLinks is the class of the enclosing div.
      def page_links(collection, padding = 3)
        current = collection.current_page
        pages   = collection.pages
        
        tag(:div, :class => 'pageLinks') do
          if current_page == 1
            tag(:span, '&laquo;', :class => 'pageDisabled pagePrevious')
          else
            tag(:a, '&laquo;', :href => page_url(current - 1), :class => 'pagePrevious')
          end
          
          page_set(current, pages, padding).each do |page|
            case page
            when 0
              tag(:span, "...", :class => 'pageSpacer')
            when current
              tag(:span, page, :class => 'pageCurrent')
            else
              tag(:a, page, :href => page_url(page), :class => 'pageNumber')
            end
          end
        
          if current == pages
            tag(:span, '&raquo;', :class => 'pageDisabled pageNext')
          else
            tag(:a, '&raquo;', :href => page_url(current + 1), :class => 'pageNext')
          end
        end
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
