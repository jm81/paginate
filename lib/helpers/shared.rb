module Paginate
  module Helpers
    # Shared helper methods included in other Helper modules.
    module Shared
      # +page_set+ returns an Array of page numbers that can be used by a view
      # for displaying page links. It includes the first page, the current page,
      # with up to +padding+ pages before and after, and the last page. If pages
      # are skipped between any of these groups, 0 stands in for them, as an
      # indicator to the view that, for example, elipses might be used here.
      # For example:
      #
      #    page_set(3, 10, 3)
      #    => [1, 2, 3, 4, 5, 6, 0, 10] TODO test this in particular
      #
      # The 0 at index 6 is an indication that there are skipped pages.
      def page_set(current_page, pages, padding = 3)

        # Determine first and last page in group around current page
        first = [1, current_page - padding].max
        last = [pages, current_page + padding].min

        # Determine if an additional "First page" is needed and whether any
        # pages are skipped between it and the first around the current page
        leader = case first
          when 1 then []  # First not needed
          when 2 then [1] # First needed, but none skipped
          else [1, 0]     # First needed, some skipped
        end

        # Determine if an additional "Last page" is needed and whether any
        # pages are skipped between the last around the current page and it.
        footer = case last
          when pages then []          # Last not needed
          when pages - 1 then [pages] # Last needed, but none skipped
          else [0, pages]             # Last needed, some skipped
        end

        # Join Arrays together
        leader + (first..last).to_a + footer
      end

      # Generate a URL (for page links), given a page number and
      # optionally a path and query string. By default, the path is the path
      # of the current request, and the query_string is also that of the
      # current request. This allows for order and condition related fields
      # in the query string to be used in the page link.
      def url_for_pagination(page, path = request.path, q = request.query_string)
        # Remove any current reference to page in the query string
        q = q.to_s.gsub(/page=(-?[\d]+)(&?)/, '')
        # Assemble new link
        link = "#{path}?page=#{page}&#{q}"
        link = link[0..-2] if link[-1..-1] == '&' # Strip trailing ampersand
        link
      end
    end
  end
end
