// TODO/INFO: refactor this to use Trailblazer Operations & policies?! possible?

function _isUserAssigned(entities, id) {
  let assignment = entities.assignments && entities.assignments[id]
  let currentUser = entities.users[entities['current-user-id']]

  return assignment && currentUser && assignment['receiver-id'] == currentUser.id
}

function _isTeamAssigned(entities, id) {
  let assignment = entities.assignments && entities.assignments[id]
  let teamIds = entities.users[entities['current-user-id']]['user-team-ids']

  return assignment && teamIds.includes(assignment['receiver-team-id'])
}

export function currentAssignmentIdFor(model, modelInstance) {
  if (model == 'assignments') {
    return modelInstance && modelInstance.id
  } else {
    return modelInstance && modelInstance['current-assignment-id'] ?
      modelInstance['current-assignment-id'] : undefined
  }
}

export function isCurrentUserAssignedToModel(entities, model, id) {
  let modelInstance = entities[model] && entities[model][id]
  let assignmentId = currentAssignmentIdFor(model, modelInstance)

  return modelInstance && assignmentId && _isUserAssigned(entities, assignmentId)
}

export function isTeamOfCurrentUserAssignedToModel(entities, model, id) {
  let modelInstance = entities[model] && entities[model][id]
  let assignmentId = currentAssignmentIdFor(model, modelInstance)

  return modelInstance && assignmentId && _isTeamAssigned(entities, assignmentId)
}
