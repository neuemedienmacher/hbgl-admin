# frozen_string_literal: true

module Assignable
  class Twin < Disposable::Twin
    collection :assignments
    property :current_assignment

    # Methods
    # NOTE: for later use
    # def field_assignments
    #   assignments.field
    # end

    # the current assignment must be active (open), a root assignment (no
    # parent) and it must belong to the model (and not to a field of the model).
    # There must always be exactly one current_assignment for each assignable.
    # def current_assignment
    #   assignments.active.root.base.first
    # end

    # NOTE: for later use
    # def current_field_assignment field
    #   # return nil if the required field is not existing on the assignable model
    #   return nil unless respond_to?(field)
    #   # return open field assignment if one exists or current model assignment
    #   assignments.active.root.where(assignable_field_type: field).first ||
    #     current_assignment
    # end

    def should_be_created_by_system?
      case model.class.to_s
      when 'OfferTranslation', 'OrganizationTranslation'
        model.locale == 'de' || !model.translated_model.in_section?('refugees')
      else
        false # NOTE: this is not used yet - rethink when other models become assignable!
      end
    end

    def should_create_new_assignment?
      case model.class.to_s
      # only re-assign refugees translations, that are outdated or from GT and
      # if they are not already assigned to the translator team
      when 'OfferTranslation', 'OrganizationTranslation'
        translation_twin = ::Translation::Twin.new(model)
        current_assignment.nil? ||
          translation_twin.currently_assigned_to_system_user? &&
            translation_twin.should_be_reviewed_by_translator?
      # only re-assign Divisions that are done and not assigned to system_user
      when 'Division'
        model.done == true && assigned_to_system? == false
      else
        false # NOTE: this is not used yet - rethink when other models become assignable!
      end
    end

    def assigned_to_system?
      current_assignment.receiver_id == ::User.system_user.id
    end

    # TODO: Sub-Assignments (assignment with parent)
  end
end
