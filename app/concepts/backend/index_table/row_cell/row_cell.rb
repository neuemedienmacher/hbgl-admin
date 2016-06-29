# frozen_string_literal: true
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

    def truncated_title field
      content = data_content(field)
      return if content.length <= 40
      " title='#{content}'"
    end

    def data_content field
      concept('backend/index_table/column_cell', model.send(field), @options)
        .call
    end

    def edit_link(&block)
      link_to send(:"edit_#{model_name}_path", model), &block
    end

    def model_name
      model.class.name.tableize.singularize
    end
  end
end
