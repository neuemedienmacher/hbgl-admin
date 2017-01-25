# frozen_string_literal: true
class Assignment::CreateInitial < Trailblazer::Operation
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
      creator_team_id: creator_team_id(assignable, last_acting_user),
      receiver_id: receiver_id(assignable, last_acting_user),
      receiver_team_id: receiver_team_id,
      message: message_for_new_assignment(assignable)
    }
  end

  # --- Utils describing default logic --- #

  def creator(assignable, last_acting_user)
    case assignable.class
    when OfferTranslation, OrganizationTranslation
      created_by_system? ? User.system_user : last_acting_user
    else
      last_acting_user
    end
  end

  # Note: We are not yet sure whether this will be useful, but we're collecting
  # the data for now.
  def creator_team_id(assignable, last_acting_user)
    creator(assignable, last_acting_user).current_team.try(:id)
  end

  def receiver_id(assignable, last_acting_user)
    case assignable.class
    when OfferTranslation, OrganizationTranslation
      ::User.system_user.id
    else
      last_acting_user.id
    end
  end

  def receiver_team_id
    nil
  end

  def message_for_new_assignment(assignable)
    case assignable.class
    when OfferTranslation, OrganizationTranslation
      'Initiale Zuweisung für Übersetzungen'
    else
      'Initial Assignment'
    end
  end

  # TODO: Does this not belong in decorator for assignable?
  def created_by_system?
    binding.pry
    assignable.locale == 'de' || !assignable['offer/orga'].in_section?('refugees')
  end
end
