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
          html = ''
          if current == 1
            html << tag(:span, '&laquo;', :class => 'pageDisabled pagePrevious')
          else
            html << tag(:a, '&laquo;', :href => url_for_pagination(current - 1), :class => 'pagePrevious')
          end
          
          page_set(current, pages, padding).each do |page|
            case page
            when 0
              html << tag(:span, "...", :class => 'pageSpacer')
            when current
              html << tag(:span, page, :class => 'pageCurrent')
            else
              html << tag(:a, page, :href => url_for_pagination(page), :class => 'pageNumber')
            end
          end
        
          if current == pages
            html << tag(:span, '&raquo;', :class => 'pageDisabled pageNext')
          else
            html << tag(:a, '&raquo;', :href => url_for_pagination(current + 1), :class => 'pageNext')
          end
          html
        end
      end
    end
  end
end
