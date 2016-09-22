# frozen_string_literal: true
module Backend::FormFields
  class FilteringMultiselectCell < Cell::Concept
    def show
      render
    end

    private

    def form
      options[:f]
    end

    def field_name
      options[:field].to_s.downcase
    end

    # field_name offer_ids ~> offers
    def association_name
      field_name.sub('_id', '')
    end

    def js_data
      {
        xhr: true,
        remote_source: send("api_v1_#{association_name}_path")
      }
    end

    def collection
      []
    end
  end
end
