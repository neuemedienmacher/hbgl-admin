module Backend::IndexTable
  class RowCell < Cell::Concept
    include ActionView::Helpers::UrlHelper

    def show
      render
    end

    private

    def list_settings
      @options[:settings]['list']
    end

    def columns
      list_settings['fields'].map do |field|
        "<td #{truncated_title(field)}>" + data_content(field) + '</td>'
      end.join
    end

    def data_content field
      raw_data_content(field).truncate(40)
    end

    def truncated_title field
      content = raw_data_content(field)
      return if content.length <= 40
      " title='#{content}'"
    end

    def raw_data_content field
      concept('backend/index_table/column_cell', model.send(field), @options).()
    end

    def edit_link(&block)
      link_to edit_offer_path(model), &block
    end
  end
end
