# frozen_string_literal: true
module API::V1
  module BaseTranslation
    class DynamicFind
      def initialize(locale, object_type, object_id)
        @locale = locale
        @object_type = object_type
        @object_id = object_id
      end

      def find_or_create
        translation_class = "#{@object_type}Translation".constantize
        object_id_field = "#{@object_type.downcase}_id"

        # return existing translation if one is found
        translation =
          translation_class.find_by locale: @locale, object_id_field => @object_id
        return translation if translation

        # otherwise create a new one (via operation that also creates the
        # initial assignment) and return it
        "API::V1::#{@object_type}Translation::Create"
          .constantize.(json: params_hash(object_id_field)).model
      end

      private

      # TODO do this differently ?!
      def params_hash object_id_field
        {
          data: {
            attributes:
            {
              locale: @locale.to_s, object_id_field => @object_id.to_s,
              source: 'GoogleTranslate'
            }
          }
        }.to_json
      end
    end
  end
end
