// TODO/INFO: refactor this to use Trailblazer Operations & policies?! possible?

function _isUserAssigned(entities, id) {
  let assignment = entities.assignments && entities.assignments[id]
  let current_user = entities.current_user

  return assignment && current_user && assignment.receiver_id == current_user.id
}

function _isTeamAssigned(entities, id) {
  let assignment = entities.assignments && entities.assignments[id]
  let team_ids = entities.users[entities.current_user.id].user_team_ids

  return assignment && team_ids.includes(assignment.receiver_team_id)
}

export function currentAssignmentIdFor(model, model_instance) {
  if (model == 'assignments') {
    return model_instance && model_instance.id
  } else {
    return model_instance && model_instance.current_assignment &&
      model_instance.current_assignment.id ? model_instance.current_assignment.id : undefined
  }
}

export function isCurrentUserAssignedToModel(entities, model, id) {
  let model_instance = entities[model] && entities[model][id]
  let assignment_id = currentAssignmentIdFor(model, model_instance)

  return model_instance && assignment_id && _isUserAssigned(entities, assignment_id)
}

export function isTeamOfCurrentUserAssignedToModel(entities, model, id) {
  let model_instance = entities[model] && entities[model][id]
  let assignment_id = currentAssignmentIdFor(model, model_instance)

  return model_instance && assignment_id && _isTeamAssigned(entities, assignment_id)
}
