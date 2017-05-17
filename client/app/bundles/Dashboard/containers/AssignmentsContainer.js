import { connect } from 'react-redux'
import filter from 'lodash/filter'
import valuesIn from 'lodash/valuesIn'
import AssignmentsContainer from '../components/AssignmentsContainer'

const mapStateToProps = (state, ownProps) => {
  const scope = ownProps.scope
  const model = 'assignments'
  const user = state.entities.users[state.entities.current_user.id]
  let system_user =
    filter(state.entities.users, {'name': 'System'} )[0]

  let itemId = user.id
  let selectableData = []
  if (scope == 'receiverTeam'){
    selectableData = valuesIn(state.entities.user_teams).filter(
      team => user.user_team_ids.includes(team.id)
    ).map(team => [team.id, team.name])
    let selectIdentifier = 'controlled-select-view-team-assignments'
    itemId = state.ui[selectIdentifier] !== undefined ?
             state.ui[selectIdentifier] :
             selectableData[0][0]
  }
  const lockedParams = lockedParamsFor(scope, itemId, system_user.id)
  const optionalParams =
    { 'sort_field': 'created_at', 'sort_direction': 'DESC' }
  const heading = headingFor(scope)

  return {
    heading,
    model,
    lockedParams,
    optionalParams,
    scope,
    selectableData
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function headingFor(scope) {
  switch(scope) {
  case 'receiver':
    return 'Dir zugewiesene, offene Aufgaben:'
  case 'creatorOpen':
    return 'Von dir erstellte, offene Aufgaben:'
  case 'receiverClosed':
    return 'Von dir empfangene, abgeschlossene Aufgaben:'
  case 'receiverTeam':
    return 'Diesem Team zugewiesene, offene Aufgaben: '
  default:
    return ''
  }
}

function lockedParamsFor(scope, id, systemId) {
  switch(scope) {
  case 'receiver':
    return {
      'filters[receiver-id]': id, 'per_page': 10, 'filters[aasm-state]': 'open'
    }
  case 'creatorOpen':
    return {
      'filters[creator_id]': id, 'filters[aasm-state]': 'open', 'per_page': 10,
      'filters[receiver-id]': systemId, 'operators[receiver-id]': '!=',
      'filters[created-by-system]': 'false'
    }
  case 'receiverClosed':
    return {
      'filters[receiver-id]': id, 'per_page': 10, 'filters[aasm-state]': 'closed'
    }
  case 'receiverTeam':
    return {
      'filters[receiver-team-id]': id, 'filters[receiver-id]': 'nil',
      'operators[receiver-id]': '=', 'per_page': 10,
      'filters[aasm-state]': 'open'
    }
  default:
    return {}
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentsContainer)
