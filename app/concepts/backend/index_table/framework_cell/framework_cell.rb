# frozen_string_literal: true
module Backend::IndexTable
  class FrameworkCell < Cell::Concept
    def show
      render
    end

    protected

    PER_PAGE = 20

    def current_page
      params[:page] ? (params[:page].to_i - 1) : 0
    end

    def page_count
      (unlimited_index_objects.count.to_f / PER_PAGE).ceil
    end

    def last_page
      page_count - 1
    end

    def current_order
      if params[:sort]
        "#{params[:sort]} #{current_direction}"
      else
        list_settings['order']
      end
    end

    def current_direction
      (params[:direction] == 'DESC') ? 'DESC' : 'ASC'
    end

    def merged_params kept_params, obj
      params.slice(*kept_params).merge obj
    end

    private

    def settings
      @options[:settings] || {}
    end

    def list_settings
      settings['list']
    end

    def column_fields
      list_settings['fields']
    end

    def header_sort_link field
      if params[:sort] == field
        reverse_direction = (current_direction == 'DESC') ? 'ASC' : 'DESC'
        link_to sorted_link_anchor(field), merged_params(
          kept_params_for_sort_link,
          sort: field, direction: reverse_direction
        )
      else
        link_to field, merged_params(kept_params_for_sort_link, sort: field)
      end
    end

    def kept_params_for_sort_link
      [:search]
    end

    def sorted_link_anchor field
      symbol_class = if current_direction == 'DESC'
                       'fui-triangle-up-small'
                     else
                       'fui-triangle-down-small'
                     end
      "<u>#{field}</u> <i class='#{symbol_class}'></i>"
    end

    def rows
      concept 'backend/index_table/row_cell', { collection: index_objects },
              @options
    end

    def pagination
      concept 'backend/index_table/pagination_cell', model, @options
    end

    def pagination_needed?
      page_count > 1
    end

    def unlimited_index_objects
      objects = model
      objects = search_modify(objects) if params[:search]
      objects
    end

    def index_objects
      unlimited_index_objects
        .limit(PER_PAGE)
        .offset(current_page * PER_PAGE)
        .order(current_order)
    end

    def search_modify objects
      objects.search_everything(params[:search])
      # objects.where('LOWER(name) LIKE LOWER(?)', "%#{params[:search]}%")
    end
  end
end
