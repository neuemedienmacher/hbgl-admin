import { connect } from 'react-redux'
import AssignmentActions from '../components/AssignmentActions'
import { isTeamOfCurrentUserAssignedToModel, isCurrentUserAssignedToModel }
  from '../../../lib/restrictionUtils'
import settings from '../../../lib/settings'
import { pluralize } from '../../../lib/inflection'
import clone from 'lodash/clone'
import filter from 'lodash/filter'
import kebabCase from 'lodash/kebabCase'
import valuesIn from 'lodash/valuesIn'
import orderBy from 'lodash/orderBy'

const mapStateToProps = (state, ownProps) => {
  const assignment = ownProps.assignment
  const type = kebabCase(assignment['assignable-type'])
  const model = pluralize(type)
  const assignableFormId = `GenericForm-${type}-${assignment['assignable-id']}`
  const assignableFormChanges = state.rform[assignableFormId] ?
    state.rform[assignableFormId]['_changes'] : state.rform[assignableFormId]
  let assignableChanged = assignableFormChanges && assignableFormChanges.length
  let assignments = filter(
    state.entities.assignments,
    a => {
      return a['assignable-type'] == assignment['assignable-type'] &&
             a['assignable-id'] == assignment['assignable-id']
    }
  )
  let settingsActions = settings.index[model]['assignment-actions'] ||
    settings.index.assignable['assignment-actions']
  let systemUser = filter(state.entities.users, {'name': 'System'} )[0]
  const users = orderBy(valuesIn(state.entities.users).filter(user => (
    user.name != 'System' && user.id != state.entities['current-user-id'] &&
    user.active
  )).map(user => ({
    name: user.name + ` (${involvementCount(assignments, user.id)})`,
    value: user.id, sortValue: involvementCount(assignments, user.id)
  })), ['sortValue', 'name'],  ['desc', 'asc'])
  const teams = valuesIn(state.entities['user-teams']).filter(team => (
    team.name.indexOf('ARCHIV') < 0 && team.name.indexOf('Developers') < 0
  )).map(team => ({ name: team.name, value: team.id }))
  users.push({ name: '-', sortValue: -1,  value: '' })
  teams.unshift({ name: '-', value: '' })
  const actions = settingsActions.filter(
    action => visibleFor(action, state.entities, model,
                         assignment['assignable-id'], systemUser)
  ).map(action => ({
    buttonText: buttonTextFor(action),
    href: '/api/v1/assignments/',
    formId: `Assignment${assignment.id}:${action}`,
    seedData: seedDataFor(action, state.entities, assignment, systemUser, users),
    additionalChoices: action == 'assign-someone-else',
    messageField: action != 'assign-to-system' && action != 'assign-to-current-user'
  }))
  const topics = state.settings.assignments.topics.map(topic => ({
    name: topic,
    value: topic
  }))

  return {
    assignment,
    actions,
    users,
    teams,
    topics,
    assignableChanged,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  afterResponse(_) {
    // call dataLoad-Function of the assignable to update current_assignment
    if(ownProps.assignableDataLoad) ownProps.assignableDataLoad()
  }
})

function visibleFor(action, entities, model, id, systemUser) {
  switch(action) {
    case 'assign-to-current-user':
      return isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    case 'assign-someone-else':
      return isCurrentUserAssignedToModel(entities, model, id) ||
        isTeamOfCurrentUserAssignedToModel(entities, model, id)
    case 'retrieve-assignment':
      return !isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    case 'assign-to-system':
      // NOTE: only assigned users in translator-teams may directly assign the
      // systemUser (only to Translations)
      let currentUser = entities.users[entities['current-user-id']]
      let teamRoles = filter(
        entities['user-teams'],
        team => { return currentUser['user-team-ids'].includes(team.id) }
      ).map( team => team.classification )
      return isCurrentUserAssignedToModel(entities, model, id) && systemUser &&
        ['offer-translations', 'organization-translations'].includes(model) &&
        teamRoles.includes('translator')
    default:
      return false
  }
}

function buttonTextFor(action) {
  switch(action) {
  case 'assign-someone-else':
    return 'Neu zuweisen'
  case 'assign-to-current-user':
    return 'Mir zuweisen'
  case 'retrieve-assignment':
    return 'Neue Zuweisung öffnen'
  case 'assign-to-system':
    return 'Zuweisung schließen!'
  }
}

function seedDataFor(action, entities, assignment, systemUser, users) {
  let assignment_copy = clone(assignment)
  assignment_copy['id'] = undefined
  assignment_copy['created-by-system'] = false
  switch(action) {
  case 'assign-to-current-user':
    assignment_copy['receiver-id'] = entities['current-user-id']
    break
  case 'assign-someone-else':
    assignment_copy['creator-id'] = entities['current-user-id']
    assignment_copy['receiver-id'] = users[0].value
    assignment_copy['creator-team-id'] = undefined
    assignment_copy['receiver-team-id'] = undefined
    assignment_copy.message = ''
    break
  case 'retrieve-assignment':
    assignment_copy['creator-id'] = entities['current-user-id']
    assignment_copy['creator-team-id'] = undefined
    assignment_copy['receiver-team-id'] = undefined
    assignment_copy['receiver-id'] = entities['current-user-id']
    assignment_copy.message = ''
    break
  case 'assign-to-system':
    assignment_copy['creator-id'] = entities['current-user-id']
    assignment_copy['receiver-id'] = systemUser.id
    assignment_copy['creator-team-id'] = undefined
    assignment_copy['receiver-team-id'] = undefined
    assignment_copy.message = 'Erledigt!'
    break
  }
  return {fields: assignment_copy}
}

function involvementCount(assignments, userID) {
  // Maybe only count one thing (creator or receiver)
  let assignmentCount = valuesIn(assignments).filter(assignment => (
    assignment['creator-id'] == userID || assignment['receiver-id'] == userID
  )).length
  return assignmentCount
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentActions)
