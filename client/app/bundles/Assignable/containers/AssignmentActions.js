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
import AssignmentActionFormObject from '../forms/AssignmentActionFormObject'
import AssignmentFormObject from '../../NewAssignment/forms/AssignmentFormObject'

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
    icon: iconFor(action),
    href: assignableRouteForAction(action, 'assignments', assignment.id),
    formId: `Assignment${assignment.id}:${action}`,
    seedData: seedDataFor(action, state.entities, assignment),
    method: action == 'assign_to_user' ? 'POST' : 'PATCH',
    formObjectClass: action == 'assign_to_user' ? AssignmentFormObject : AssignmentActionFormObject
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

function seedDataFor(action, entities, assignment) {
  let assignment_copy = clone(assignment)
  switch(action) {
  case 'assign_and_edit_assignable':
    assignment_copy.reciever_id = entities.current_user.id
    break
  case 'close_assignment':
    assignment_copy.aasm_state = 'closed'
    break
  case 'assign_to_user':
    assignment_copy.creator_id = entities.current_user.id
    assignment_copy.creator_team_id = entities.current_user.current_team_id
    assignment_copy.reciever_id = entities.current_user.id
    assignment_copy.reciever_team_id = entities.current_user.current_team_id
    assignment_copy.message = entities.current_user.name + ' self-assigned this!'
    break
  }
  return {fields:assignment_copy}
}

function iconFor(action) {
  switch(action) {
  case 'edit_assignable':
    return 'fui-new'
  case 'close_assignment':
    return 'fui-check'
  case 'assign_to_user':
    return 'fui-lock'
  case 'assign_and_edit_assignable':
    return 'fui-user'
  }
}

function visibleFor(action, entities, model, id) {
  switch(action) {
    case 'edit_assignable':
      return isCurrentUserAssignedToModel(entities, model, id)
    case 'assign_and_edit_assignable':
      return isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    case 'close_assignment':
      return isCurrentUserAssignedToModel(entities, model, id)
    case 'assign_to_user':
      return !isCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    default:
      return true
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentActions)
