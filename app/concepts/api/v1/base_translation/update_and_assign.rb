# frozen_string_literal: true
module API::V1
  module BaseTranslation
    class Update < API::V1::Assignable::Update
      def initialize(translation, object , fields)
        @object = object
        @fields = fields
        @model = translation
      end

      def update_and_assign
        # update fields and save model
        @model.assign_attributes(@fields)
        @model.save!

        # call process of Assignable::Update for Assignment logic
        process(nil)
      end

      protected

      # override default Assignable::Update logic
      def assignment_creator_id
        @object.created_by
      end

      def assignment_reciever_id
        nil
      end

      def assignment_reciever_team_id
        AssignmentDefaults.translator_teams[@model.locale.to_s]
      end

      def reassign?
        @object.section_filters.pluck(:identifier).include?('refugees') &&
          @model.manually_editable? && (@model.possibly_outdated ||
          @model.source == 'GoogleTranslate')
      end

      def message_for_new_assignment
        @model.possibly_outdated ? 'possibly_outdated' : 'GoogleTranslate'
      end
    end
  end
end
