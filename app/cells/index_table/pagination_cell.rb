# TODO: Shorten page list if too many pages exist
module IndexTable
  class PaginationCell < FrameworkCell
    def show
      render
    end

    private

    def page_link(humanized_page_number, anchor, link_class = nil)
      if humanized_page_number >= 1 && humanized_page_number <= page_count
        link_to anchor, merged_params(
          kept_params_for_page_link, page: humanized_page_number
        ), class: link_class
      else
        link_to anchor, 'javascript:;', class: link_class
      end
    end

    def kept_params_for_page_link
      [:sort, :direction, :search]
    end

    def previous_disabled_class
      'disabled' if current_page == 0
    end

    def page_active_class(humanized_page_number)
      'active' if humanized_page_number == (current_page + 1)
    end

    def next_disabled_class
      'disabled' if current_page == last_page
    end
  end
end
