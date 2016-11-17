import { connect } from 'react-redux'
import AssignmentActions from '../components/AssignmentActions'
import addEntities from '../../../Backend/actions/addEntities'
import { isTeamOfCurrentUserAssignedToModel, isCurrentUserAssignedToModel }
  from '../../../lib/restrictionUtils'
import settings from '../../../lib/settings'
import snakeCase from 'lodash/snakeCase'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import { assignableRouteForAction } from '../../../lib/routeForAction'

const mapStateToProps = (state, ownProps) => {
  const assignment = ownProps.assignment
  // TODO: 'pluralization' may be wrong, but works for now (Translations)
  let model = snakeCase(assignment.assignable_type) + 's'
  let settings_actions = settings.index[model].assignment_actions ||
    settings.index.assignable.assignment_actions
  // console.log(settings_actions)

  const actions = settings_actions.filter(
    action => visibleFor(action, state.entities, model, assignment.assignable_id)
  ).map(action => ({
    buttonText: buttonTextFor(action),
    href: assignableRouteForAction(action, 'assignments', assignment.id),
    formId: `Assignment${assignment.id}:${action}`,
    seedData: seedDataFor(action, state.entities, assignment),
    method: action == 'assign_to_current_user' ? 'PATCH' : 'POST',
  }))
  // console.log(assignableDataLoad)
  // console.log(assignment)
  // console.log(state)

  return {
    assignment,
    actions
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  handleResponse(_formId, data){
    console.log('=========handleResponse==========')
    console.log(data)
    dispatch(addEntities(data))
    // call dataLoad-Function of the assignable to update current_assignment
    if(ownProps.assignableDataLoad){
      ownProps.assignableDataLoad()
    }
  },

  afterResponse(response) {
    console.log('=========afterResponse==========')
    console.log(response)
  }
})

function visibleFor(action, entities, model, id) {
  switch(action) {
    case 'assign_to_current_user':
      return isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    case 'reply_to_assignment':
      return isCurrentUserAssignedToModel(entities, model, id)
    case 'assign_from_system':
      return !isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    default:
      return false
  }
}

function buttonTextFor(action) {
  switch(action) {
  case 'reply_to_assignment':
    return 'Zurückgeben/Antworten/?'
  case 'assign_to_current_user':
    return 'Mir zuweisen'
  case 'assign_from_system':
    return 'Neue Zuweisung öffnen'
  }
}

function seedDataFor(action, entities, assignment) {
  let assignment_copy = clone(assignment)
  switch(action) {
  case 'assign_to_current_user':
    assignment_copy.reciever_id = entities.current_user.id
    break
  case 'reply_to_assignment':
    assignment_copy.creator_id = entities.current_user.id
    assignment_copy.creator_team_id = entities.current_user.current_team_id
    assignment_copy.reciever_id = assignment.creator_id
    assignment_copy.reciever_team_id = assignment.creator_team_id
    assignment_copy.message = 'Erledigt!'
    break
  case 'assign_from_system':
    // TODO: system_user id from defaults
    assignment_copy.creator_id = assignment.reciever_id
    assignment_copy.creator_team_id = undefined
    assignment_copy.reciever_id = entities.current_user.id
    assignment_copy.reciever_team_id = entities.current_user.current_team_id
    assignment_copy.message = ''
    break
  }
  return {fields: assignment_copy}
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentActions)
