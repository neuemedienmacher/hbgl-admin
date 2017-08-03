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
      def create_optional_assignment_for_organization_translation!(
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

      def create_optional_assignment_for_organization!(_options, model:, **)
        return true unless model.class == Assignment &&
                           model.assignable_type == 'Division' &&
                           model.assignable.organization
        organization = model.assignable.organization
        if should_create_automated_organization_assignment?(model, organization)
          receiving_user = User.find(model.receiver_id)
          ::Assignment::CreateBySystem.(
            {}, assignable: organization, last_acting_user: receiving_user
          ).success?
        else
          true
        end
      end

      def should_create_automated_organization_assignment?(model, organization)
        orga_twin = ::Assignable::Twin.new(organization)
        !model.receiver_id.nil? && model.receiver_id != ::User.system_user.id &&
          orga_twin.current_assignment.receiver_id == ::User.system_user.id &&
          organization.initialized?
      end
    end
  end
end
