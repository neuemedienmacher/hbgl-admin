import { connect } from 'react-redux'
import AssignmentActions from '../components/AssignmentActions'
import {
  isTeamOfCurrentUserAssignedToModel,
  isCurrentUserAssignedToModel,
} from '../../../lib/restrictionUtils'
import settings from '../../../lib/settings'
import { pluralize } from '../../../lib/inflection'
import clone from 'lodash/clone'
import filter from 'lodash/filter'
import kebabCase from 'lodash/kebabCase'
import valuesIn from 'lodash/valuesIn'
import orderBy from 'lodash/orderBy'

const buttonTextFor = {
  'assign-someone-else': 'Neu zuweisen',
  'assign-to-current-user': 'Mir zuweisen',
  'retrieve-assignment': 'Neue Zuweisung öffnen',
  'assign-to-system': 'Zuweisung schließen!',
}

function involvementCount(assignments, userID) {
  // Maybe only count one thing (creator or receiver)
  const assignmentCount = valuesIn(assignments).filter(
    (assignment) =>
      assignment['creator-id'] === userID ||
      assignment['receiver-id'] === userID
  ).length
  return assignmentCount
}

function visibleFor(action, entities, model, id, systemUser) {
  switch (action) {
    case 'assign-to-current-user':
      return (
        isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
      )
    case 'assign-someone-else':
      return (
        isCurrentUserAssignedToModel(entities, model, id) ||
        isTeamOfCurrentUserAssignedToModel(entities, model, id)
      )
    case 'retrieve-assignment':
      return (
        !isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
      )
    case 'assign-to-system':
      // NOTE: only assigned users in may directly assign certain models to the
      // system-user
      return (
        isCurrentUserAssignedToModel(entities, model, id) &&
        systemUser &&
        [
          'offer-translations',
          'organization-translations',
          'websites',
        ].includes(model)
      )
    default:
      return false
  }
}

function seedDataFor(action, entities, assignment, systemUser, users) {
  const assignmentCopy = clone(assignment)
  assignmentCopy.id = undefined
  assignmentCopy['created-by-system'] = false
  switch (action) {
    case 'assign-to-current-user':
      assignmentCopy['receiver-id'] = entities['current-user-id']
      break
    case 'assign-someone-else':
      assignmentCopy['creator-id'] = entities['current-user-id']
      assignmentCopy['receiver-id'] = users[0].value
      assignmentCopy['creator-team-id'] = undefined
      assignmentCopy['receiver-team-id'] = undefined
      assignmentCopy.message = ''
      break
    case 'retrieve-assignment':
      assignmentCopy['creator-id'] = entities['current-user-id']
      assignmentCopy['creator-team-id'] = undefined
      assignmentCopy['receiver-team-id'] = undefined
      assignmentCopy['receiver-id'] = entities['current-user-id']
      assignmentCopy.message = ''
      break
    case 'assign-to-system':
      assignmentCopy['creator-id'] = entities['current-user-id']
      assignmentCopy['receiver-id'] = systemUser.id
      assignmentCopy['creator-team-id'] = undefined
      assignmentCopy['receiver-team-id'] = undefined
      assignmentCopy.message = 'Erledigt!'
      break
  }
  return { fields: assignmentCopy }
}

const mapStateToProps = (state, ownProps) => {
  const assignment = ownProps.assignment
  const type = kebabCase(assignment['assignable-type'])
  const model = pluralize(type)
  const assignableFormId = `GenericForm-${type}-${assignment['assignable-id']}`
  const assignableFormChanges = state.rform[assignableFormId]
    ? state.rform[assignableFormId]._changes
    : state.rform[assignableFormId]
  const assignableChanged =
    assignableFormChanges && assignableFormChanges.length
  const assignments = filter(state.entities.assignments, (a) => {
    return (
      a['assignable-type'] === assignment['assignable-type'] &&
      a['assignable-id'] === assignment['assignable-id']
    )
  })
  const settingsActions =
    settings.index[model]['assignment-actions'] ||
    settings.index.assignable['assignment-actions']
  const systemUser = filter(state.entities.users, { name: 'System' })[0]
  const users = orderBy(
    valuesIn(state.entities.users)
      .filter(
        (user) =>
          user.name !== 'System' &&
          user.id !== state.entities['current-user-id'] &&
          user.active
      )
      .map((user) => ({
        name: user.name + ` (${involvementCount(assignments, user.id)})`,
        value: user.id,
        sortValue: involvementCount(assignments, user.id),
      })),
    ['sortValue', 'name'],
    ['desc', 'asc']
  )
  const teams = valuesIn(state.entities['user-teams'])
    .filter(
      (team) =>
        team.name.indexOf('ARCHIV') < 0 && team.name.indexOf('Developers') < 0
    )
    .map((team) => ({ name: team.name, value: team.id }))
  users.push({ name: '-', sortValue: -1, value: '' })
  teams.unshift({ name: '-', value: '' })
  const actions = settingsActions
    .filter((action) =>
      visibleFor(
        action,
        state.entities,
        model,
        assignment['assignable-id'],
        systemUser
      )
    )
    .map((action) => ({
      buttonText: buttonTextFor[action],
      href: '/api/v1/assignments/',
      formId: `Assignment${assignment.id}:${action}`,
      seedData: seedDataFor(
        action,
        state.entities,
        assignment,
        systemUser,
        users
      ),
      additionalChoices: action === 'assign-someone-else',
      messageField:
        action !== 'assign-to-system' && action !== 'assign-to-current-user',
    }))
  const topics = state.settings.assignments.topics.map((topic) => ({
    name: topic,
    value: topic,
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
    if (ownProps.assignableDataLoad) ownProps.assignableDataLoad()
  },
})

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentActions)
