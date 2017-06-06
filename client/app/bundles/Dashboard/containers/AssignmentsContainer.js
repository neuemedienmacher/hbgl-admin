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
  let selectable_data = []
  if (scope == 'receiver_team'){
    selectable_data = valuesIn(state.entities.user_teams).filter(
      team => user.user_team_ids.includes(team.id)
    ).map(team => [team.id, team.name])
    let selectIdentifier = 'controlled-select-view-team-assignments'
    itemId = state.ui[selectIdentifier] !== undefined ?
             state.ui[selectIdentifier] :
             selectable_data[0][0]
  }
  const lockedParams = lockedParamsFor(scope, itemId, system_user.id)
  const optionalParams =
    { 'sort_field': 'updated_at', 'sort_direction': 'DESC' }
  const heading = headingFor(scope)

  return {
    heading,
    model,
    lockedParams,
    optionalParams,
    scope,
    selectable_data
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function headingFor(scope) {
  switch(scope) {
  case 'receiver':
    return 'Dir zugewiesene, offene Aufgaben:'
  case 'creator_open':
    return 'Von dir erstellte, offene Aufgaben:'
  case 'receiver_closed':
    return 'Von dir empfangene, abgeschlossene Aufgaben:'
  case 'receiver_team':
    return 'Diesem Team zugewiesene, offene Aufgaben: '
  default:
    return ''
  }
}

function lockedParamsFor(scope, id, sys_id) {
  switch(scope) {
  case 'receiver':
    return {
      'filters[receiver_id]': id, 'per_page': 10, 'filters[aasm_state]': 'open'
    }
  case 'creator_open':
    return {
      'filters[creator_id]': id, 'filters[aasm_state]': 'open', 'per_page': 10,
      'filters[receiver_id]': sys_id, 'operators[receiver_id]': '!=',
      'filters[created_by_system]': 'false'
    }
  case 'receiver_closed':
    return {
      'filters[receiver_id]': id, 'per_page': 10, 'filters[aasm_state]': 'closed'
    }
  case 'receiver_team':
    return {
      'filters[receiver_team_id]': id, 'filters[receiver_id]': 'nil',
      'operators[receiver_id]': '=', 'per_page': 10,
      'filters[aasm_state]': 'open'
    }
  default:
    return {}
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentsContainer)
