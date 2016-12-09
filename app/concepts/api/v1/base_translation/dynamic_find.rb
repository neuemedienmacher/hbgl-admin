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

        # get user-ID for initial assignment - logic might change later
        object = @object_type.constantize.find(@object_id)
        user_id =  object.approved_by ? object.approved_by : object.created_by
        # otherwise create a new one (via operation that also creates the
        # initial assignment) and return it
        "API::V1::#{@object_type}Translation::Create"
          .constantize.(json: params_hash(object_id_field),
                        current_user: {id: user_id}).model
      end

      private

      # REFACTORING: do this differently ?!
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
