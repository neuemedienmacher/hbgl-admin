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
      edit_path = send(:"edit_#{model_name}_path", model)
      if edit_path && policy.edit?
        link_to edit_path, &block
      else
        nil
      end
    end

    def show_link(&block)
      show_path = send(:"#{model_name}_path", model)
      if show_path && policy.show?
        link_to show_path, &block
      else
        nil
      end
    end

    def model_name
      model.class.name.tableize.singularize
    end

    def policy
      "#{model.class.name}Policy".constantize.new(current_user, model)
    end

    def current_user
      @options[:current_user]
    end
  end
end
