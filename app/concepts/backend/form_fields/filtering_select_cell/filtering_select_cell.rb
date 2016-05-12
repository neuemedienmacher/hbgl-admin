# frozen_string_literal: true
module Backend::FormFields
  class FilteringSelectCell < Cell::Concept
    def show
      render
    end

    private

    def form
      options[:f]
    end

    def field_name
      options[:field]
    end

    def js_data
      {
        xhr: true,
        remote_source: send("api_v1_#{field_name.to_s.pluralize.downcase}_path")
      }
    end

    def collection
      [%w(display_name id)]
    end
  end
end
