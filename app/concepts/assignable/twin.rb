# frozen_string_literal: true
module Assignable
  class Twin < Disposable::Twin
    collection :assignments

    # Methods
    # NOTE: for later use
    # def field_assignments
    #   assignments.field
    # end

    # the current assignment must be active (open), a root assignment (no
    # parent) and it must belong to the model (and not to a field of the model).
    # There must always be exactly one current_assignment for each assignable.
    def current_assignment
      assignments.active.root.base.first
    end

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

    # only re-assign refugees translations, that are outdated or from GT and
    # if they are not already assigned to the translator team
    def should_create_new_assignment?
      case model.class.to_s
      when 'OfferTranslation', 'OrganizationTranslation'
        translation_twin = ::Translation::Twin.new(model)
        !translation_twin.already_assigned_to_translator_team? &&
          translation_twin.should_be_reviewed_by_translator?
      else
        false # NOTE: this is not used yet - rethink when other models become assignable!
      end
    end

    # TODO: Sub-Assignments (assignment with parent)
  end
end
