# frozen_string_literal: true

module Assignable
  module CommonSideEffects
    module CreateNewAssignment
      # create initial Assignment from system for the creating user
      def create_initial_assignment!(options, model:, current_user:, **)
        result = ::Assignment::CreateBySystem.(
          {}, assignable: model, last_acting_user: current_user
        )
        if result.failure?
          result['errors']&.each_entry do |key, value|
            options['contract.default'].errors.add(key, value)
          end
        end
        result.success?
      end

      def create_new_assignment_if_assignable_should_be_reassigned!(
        _options, model:, current_user:, **
      )
        if assignable_twin(model).should_create_new_assignment?
          ::Assignment::CreateBySystem.(
            {}, assignable: model, last_acting_user: current_user
          ).success?
        else
          # touch current_assignment (sets updated_at to current time)
          model.current_assignment.touch
          true
        end
      end

      def create_new_assignment_if_save_and_close_clicked!(
        options, model:, current_user:, **
      )
        meta = options['params']['meta']
        if meta && meta['commit'] == 'closeAssignment'
          current_assignment = model.current_assignment
          params = { assignable_id: model.id, assignable_type: model.class.name,
                     creator_id: current_user.id,
                     creator_team_id: current_assignment.receiver_team_id,
                     receiver_id: User.system_user.id, receiver_team_id: nil,
                     message: 'Erledigt!', created_by_system: true,
                     topic: current_assignment.topic }
          ::Assignment::Create.(params, 'current_user' => current_user).success?
        else
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

      def assignable_twin(model)
        ::Assignable::Twin.new(model)
      end

      def should_create_automated_organization_assignment?(model, organization)
        !model.receiver_id.nil? && model.receiver_id != ::User.system_user.id &&
          organization.initialized? && [::User.system_user.id, nil].include?(
            assignable_twin(organization).current_assignment.receiver_id
          )
      end
    end
  end
end
