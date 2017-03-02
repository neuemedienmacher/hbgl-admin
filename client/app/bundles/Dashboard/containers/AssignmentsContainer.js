import { connect } from 'react-redux'
import filter_collection from 'lodash/filter'
import AssignmentsContainer from '../components/AssignmentsContainer'

const mapStateToProps = (state, ownProps) => {
  const scope = ownProps.scope
  const model = 'assignments'
  let system_user =
    filter_collection(state.entities.users, {'name': 'System'} )[0]
  const filter_query = buildQuery(scope, ownProps.item_id,system_user.id)
  let identifier = 'indexResults_' + model + '_' + scope
  const heading = headingFor(scope)

  return {
    heading,
    model,
    filter_query,
    scope
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
    return 'Deinem aktuellen Team zugewiesene, offene Aufgaben:'
  default:
    return ''
  }
}

function buildQuery(scope, id, sys_id) {
  switch(scope) {
  case 'receiver':
    return {
      'filters[receiver_id]': id, 'per_page': 10, 'filters[aasm_state]': 'open',
      'sort_field': 'created_at', 'sort_direction': 'DESC'
    }
  case 'creator_open':
    return {
      'filters[creator_id]': id, 'filters[aasm_state]': 'open', 'per_page': 10,
      'filters[receiver_id]': sys_id, 'operators[receiver_id]': '!=',
      'sort_field': 'created_at', 'sort_direction': 'DESC',
    }
  case 'receiver_closed':
    return {
      'filters[receiver_id]': id, 'per_page': 10, 'filters[aasm_state]': 'closed',
      'sort_field': 'created_at', 'sort_direction': 'DESC'
    }
  case 'receiver_team':
    return {
      'filters[receiver_team_id]': id, 'filters[receiver_id]': 'nil',
      'operators[receiver_id]': '=', 'per_page': 10,
      'filters[aasm_state]': 'open', 'sort_field': 'created_at',
      'sort_direction': 'DESC'
    }
  default:
    return {}
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentsContainer)
