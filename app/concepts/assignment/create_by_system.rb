# frozen_string_literal: true
class Assignment::CreateBySystem < Trailblazer::Operation
  # Expected options: assignable, last_acting_user
  step :collect_initial_params
  step :execute_nested_create! # Nested(Assignment::Create) !preferrably

  private

  # TODO: Use Nested() when it's possible to set params
  def execute_nested_create!(options, params:, last_acting_user:, **)
    result = Assignment::Create.(params, 'current_user' => last_acting_user)
    options['model'] = result['model']
    result.success?
  end

  def collect_initial_params(options, assignable:, last_acting_user:, **)
    options['params'] = {
      assignable_id: assignable.id,
      assignable_type: assignable.class.name,
      creator_id: creator(assignable, last_acting_user).id,
      creator_team_id: nil,
      receiver_id: receiver_id(assignable, last_acting_user),
      receiver_team_id: receiver_team_id(assignable),
      message: message_for_new_assignment(assignable, last_acting_user),
      created_by_system: true,
      topic: topic(assignable)
    }
  end

  # --- Utils describing default logic --- #
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def creator(assignable, last_acting_user)
    case assignable.class.to_s
    when 'OfferTranslation', 'OrganizationTranslation'
      assignable_twin = ::Assignable::Twin.new(assignable)
      assignable_twin.should_be_created_by_system? ? ::User.system_user : last_acting_user
    when 'ContactPersonTranslation'
      ::User.system_user
    when 'Organization'
      assignable.initialized? && assignable.assignments.any? ? ::User.system_user : last_acting_user
    else
      last_acting_user # NOTE: this is not used yet - rethink when other models become assignable!
    end
  end

  def receiver_id(assignable, last_acting_user)
    case assignable.class.to_s
    when 'OfferTranslation', 'OrganizationTranslation'
      translation_twin = ::Translation::Twin.new(assignable)
      if translation_twin.should_be_reviewed_by_translator?
        nil
      else
        ::User.system_user.id
      end
    when 'ContactPersonTranslation'
      ::User.system_user.id
    when 'Division'
      assignable.done == false ? nil : ::User.system_user.id
    when 'Organization'
      assignable.initialized? && assignable.assignments.any? ? last_acting_user.id : ::User.system_user.id
    else
      last_acting_user.id # NOTE: this is not used yet - rethink when other models become assignable!
    end
  end

  def receiver_team_id(assignable)
    case assignable.class.to_s
    when 'OfferTranslation', 'OrganizationTranslation'
      translation_twin = ::Translation::Twin.new(assignable)
      if translation_twin.should_be_reviewed_by_translator?
        AssignmentDefaults.translator_teams[assignable.locale.to_s]
      end
    when 'Division'
      if assignable.done == false
        AssignmentDefaults.screening_team
      end
    end
  end

  def topic(assignable)
    twin = ::Assignable::Twin.new(assignable)
    case assignable.class.to_s
    when 'OfferTranslation', 'OrganizationTranslation'
      'translation'
    when 'Division'
      assignable.done == false ? 'new' : twin.current_assignment.topic
    else
      twin.current_assignment ? twin.current_assignment.topic : 'new'
    end
  end

  def message_for_new_assignment(assignable, last_acting_user)
    case assignable.class.to_s
    when 'OfferTranslation', 'OrganizationTranslation'
      translation_twin = ::Translation::Twin.new(assignable)
      if translation_twin.should_be_reviewed_by_translator?
        reason = assignable.possibly_outdated? ? 'possibly_outdated' : 'GoogleTranslate'
        "(#{last_acting_user.name}) #{reason}"
      else
        'Managed by system'
      end
    when 'Division'
      if assignable.done == false
        "Bitte die #{assignable.section.identifier.capitalize}-Angebote aufnehmen"
      else
        'Managed by system'
      end
    when 'Organization'
      assignable.initialized? && assignable.assignments.any? ? 'Bitte den Orga Datensatz vervollständigen' : 'Managed by system'
    else
      'Assigned by system'
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
