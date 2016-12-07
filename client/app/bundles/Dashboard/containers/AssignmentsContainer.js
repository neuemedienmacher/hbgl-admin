import { connect } from 'react-redux'
import AssignmentsContainer from '../components/AssignmentsContainer'

const mapStateToProps = (state, ownProps) => {
  const scope = ownProps.scope
  const model = 'assignments'
  const filter_query = buildQuery(scope, ownProps.item_id)
  let identifier = 'indexResults_' + model + '_' + scope
  let count = state.ajax[identifier] ? state.ajax[identifier].meta.total_entries : 0
  const heading = headingFor(scope, count)

  return {
    heading,
    model,
    filter_query,
    scope
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function headingFor(scope, count) {
  switch(scope) {
  case 'reciever':
    return 'Dir zugewiesene, offene Aufgaben: ' + count
  case 'creator_open':
    return 'Von dir erstellte, offene Aufgaben: ' + count
  case 'creator_closed':
    return 'Von dir erstellte, abgeschlossene Aufgaben: ' + count
  case 'reciever_team':
    return 'Deinem aktuellen Team zugewiesene, offene Aufgaben: ' + count
  default:
    return ''
  }
}

function buildQuery(scope, id) {
  switch(scope) {
  case 'reciever':
    return {
      'filter[reciever_id]': id, 'per_page': 10, 'filter[aasm_state]': 'open'
    }
  case 'creator_open':
    return {
      'filter[creator_id]': id, 'per_page': 10, 'filter[aasm_state]': 'open'
    }
  case 'reciever_closed':
    return {
      'filter[reciever_id]': id, 'per_page': 10, 'filter[aasm_state]': 'closed'
    }
  case 'reciever_team':
    return {
      'filter[reciever_team]': id, 'filter[reciever_id]': 'nil', 'per_page': 10,
      'filter[aasm_state]': 'open'
    }
  default:
    return {}
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentsContainer)
