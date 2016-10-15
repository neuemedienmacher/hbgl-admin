import { connect } from 'react-redux'
import size from 'lodash/size'
import AssignmentsContainer from '../components/AssignmentsContainer'

const mapStateToProps = (state, ownProps) => {
  const scope = ownProps.scope
  const model = 'assignments'
  const filter_query = buildQuery(scope, ownProps.item_id)
  let identifier = 'indexResults_' + model + '_' + scope
  let count = state.ajax[identifier] ? size(state.ajax[identifier].data) : 0
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
  let t = scope == 'reciever' ? 'Nutzer' : 'Team'
  return 'Du hast aktuell ' + count + ' zugewiesene ' + t + '-Aufgaben:'
}

function buildQuery(scope, id) {
  switch(scope) {
  case 'reciever':
    return {'filter[reciever_id]': id, 'per_page': 10}
  case 'reciever_team':
    return {
      'filter[reciever_team]': id, 'filter[reciever_id]': 'nil', 'per_page': 10
    }
  default:
    return {}
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(AssignmentsContainer)
