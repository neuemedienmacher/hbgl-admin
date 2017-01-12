import { connect } from 'react-redux'
import AssignmentActions from '../components/AssignmentActions'
import addEntities from '../../../Backend/actions/addEntities'
import { isTeamOfCurrentUserAssignedToModel, isCurrentUserAssignedToModel,
         isCurrentUserActiveInTranslatorTeam }
  from '../../../lib/restrictionUtils'
import settings from '../../../lib/settings'
import snakeCase from 'lodash/snakeCase'
import clone from 'lodash/clone'
import filter_collection from 'lodash/filter'
import valuesIn from 'lodash/valuesIn'
import orderBy from 'lodash/orderBy'

const mapStateToProps = (state, ownProps) => {
  const assignment = ownProps.assignment
  // TODO: 'pluralization' may be wrong, but works for now (Translations)
  let model = snakeCase(assignment.assignable_type) + 's'
  let assignments = state.entities[model][assignment.assignable_id].assignments
  let settings_actions = settings.index[model].assignment_actions ||
    settings.index.assignable.assignment_actions
  let system_user =
    filter_collection(state.entities.users, {'name': 'System'} )[0]
  const users = orderBy(valuesIn(state.entities.users).filter(user => (
    user.name != 'System' && user.id != state.entities.current_user.id
  )).map(user => ({
    name: user.name + ` (${involvementCount(assignments, user.id)})`,
    value: user.id, sortValue: involvementCount(assignments, user.id)
  })), ['sortValue', 'name'],  ['desc', 'asc'])

  const actions = settings_actions.filter(
    action => visibleFor(action, state.entities, model,
                         assignment.assignable_id, system_user)
  ).map(action => ({
    buttonText: buttonTextFor(action),
    href: '/api/v1/assignments/',
    formId: `Assignment${assignment.id}:${action}`,
    seedData: seedDataFor(action, state.entities, assignment, system_user, users),
    userChoice: action == 'assign_someone_else',
    messageField: action != 'assign_to_system' && action != 'assign_to_current_user'
  }))

  return {
    assignment,
    actions,
    users
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  handleResponse(_formId, data){
    dispatch(addEntities(data))
    // call dataLoad-Function of the assignable to update current_assignment
    if(ownProps.assignableDataLoad){
      ownProps.assignableDataLoad()
    }
  },

  afterResponse(response) {
    // console.log('=========afterResponse==========')
    // console.log(response)
  }
})

function visibleFor(action, entities, model, id, system_user) {
  switch(action) {
    case 'assign_to_current_user':
      return isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    case 'assign_someone_else':
      return isCurrentUserAssignedToModel(entities, model, id)
    case 'retrieve_assignment':
      return !isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    case 'assign_to_system':
      // NOTE: only assigned users in translator-teams may directly assign the
      // system_user (only to Translations)
      let current_team = entities.current_user.current_team_id &&
        entities.user_teams[entities.current_user.current_team_id]
      return current_team && current_team.classification == 'translator' &&
        isCurrentUserAssignedToModel(entities, model, id) && system_user &&
        (model == 'offer_translations' || model == 'organization_translations')
    default:
      return false
  }
}

function buttonTextFor(action) {
  switch(action) {
  case 'assign_someone_else':
    return 'Neu zuweisen'
  case 'assign_to_current_user':
    return 'Mir zuweisen'
  case 'retrieve_assignment':
    return 'Neue Zuweisung öffnen'
  case 'assign_to_system':
    return 'Zuweisung schließen!'
  }
}

function seedDataFor(action, entities, assignment, system_user, users) {
  let assignment_copy = clone(assignment)
  switch(action) {
  case 'assign_to_current_user':
    assignment_copy.reciever_id = entities.current_user.id
    break
  case 'assign_someone_else':
    assignment_copy.creator_id = entities.current_user.id
    assignment_copy.creator_team_id = entities.current_user.current_team_id
    assignment_copy.reciever_id = users[0].value
    assignment_copy.reciever_team_id = undefined
    assignment_copy.message = ''
    break
  case 'retrieve_assignment':
    assignment_copy.creator_id = entities.current_user.id
    assignment_copy.creator_team_id = undefined
    assignment_copy.reciever_id = entities.current_user.id
    assignment_copy.reciever_team_id = entities.current_user.current_team_id
    assignment_copy.message = ''
    break
  case 'assign_to_system':
    assignment_copy.creator_id = entities.current_user.id
    assignment_copy.creator_team_id = entities.current_user.current_team_id
    assignment_copy.reciever_id = system_user.id
    assignment_copy.reciever_team_id = undefined
    assignment_copy.message = 'Erledigt!'
    break
  }
  return {fields: assignment_copy}
}

function involvementCount(assignments, userID) {
  // Maybe only count one thing (creator or reciever)
  let assignment_count = valuesIn(assignments).filter(assignment => (
    assignment.creator_id == userID || assignment.reciever_id == userID
  )).length
  return assignment_count
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentActions)
