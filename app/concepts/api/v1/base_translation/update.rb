# frozen_string_literal: true
module API::V1
  module BaseTranslation
    class Update < API::V1::Assignable::Update
      def initialize(translation, object, fields)
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
        ::User.system_user.id
      end

      def assignment_reciever_id
        assign_to_translator_team? ? nil : ::User.system_user.id
      end

      def assignment_reciever_team_id
        assign_to_translator_team? ?
          AssignmentDefaults.translator_teams[@model.locale.to_s] : nil
      end

      # only re-assign refugees translations, that are outdated or from GT and
      # if they are not already assigned to the translator team
      def reassign?
        @object.section_filters.pluck(:identifier).include?('refugees') &&
          (@model.possibly_outdated || @model.source == 'GoogleTranslate') &&
          already_assigned_to_translator_team? == false
      end

      def message_for_new_assignment
        if assign_to_translator_team?
          @model.possibly_outdated ? 'possibly_outdated' : 'GoogleTranslate'
        else
          'Managed by system'
        end
      end

      private

      def assign_to_translator_team?
        @model.manually_editable?
      end

      def already_assigned_to_translator_team?
        @model.current_assignment.reciever_team_id ==
          AssignmentDefaults.translator_teams[@model.locale.to_s]
      end
    end
  end
end
