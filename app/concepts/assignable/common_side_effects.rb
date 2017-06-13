# frozen_string_literal: true
module Assignable
  module CommonSideEffects
    module CreateNewAssignment
      # create initial Assignment from system for the creating user
      def create_initial_assignment!(_options, model:, current_user:, **)
        ::Assignment::CreateBySystem.(
          {}, assignable: model, last_acting_user: current_user
        ).success?
      end

      def create_new_assignment_if_assignable_should_be_reassigned!(
        _options, model:, current_user:, **
      )
        assignable_twin = ::Assignable::Twin.new(model)
        if assignable_twin.should_create_new_assignment?
          ::Assignment::CreateBySystem.(
            {}, assignable: model, last_acting_user: current_user
          ).success?
        else
          # touch current_assignment (sets updated_at to current time)
          assignable_twin.current_assignment.touch
          true
        end
      end

      # Side-Effect: iterate organizations and create assignments for
      # translations
      def create_assignment_for_organization_if_it_should_be_assigned!(
        options, model:, current_user:, **
      )
        return true unless model.offer && model.offer.visible_in_frontend?
        model.offer.organizations.visible_in_frontend.map do |orga|
          orga.translations.map do |translation|
            if translation.manually_editable?
              create_new_assignment_if_assignable_should_be_reassigned!(
                options, model: translation, current_user: current_user
              )
            else
              true
            end
          end.all? # NOTE: problem?
        end.all? # NOTE: u mad bro?
      end
    end
  end
end
