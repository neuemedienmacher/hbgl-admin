import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import snakeCase from 'lodash/snakeCase'
import { routeForAction } from '../../../lib/routeForAction'
import { isTeamOfCurrentUserAssignedToModel, isCurrentUserAssignedToModel }
  from '../../../lib/restrictionUtils'
import TableRow from '../components/TableRow'

const mapStateToProps = (state, ownProps) => {
  let model = ownProps.model
  let id = ownProps.row.id
  // build assignable_model for Assignments (routing to connected model)
  let assignable_model = model == 'assignments' && state.entities[model] &&
    state.entities[model][id] && state.entities[model][id].assignable_type ?
    snakeCase(state.entities[model][id].assignable_type) + 's' : '' // TODO: 'pluralization' may be wrong
  let assignable_id = model == 'assignments' && state.entities[model] &&
    state.entities[model][id] && state.entities[model][id].assignable_id

  const actions = settings.index[model].member_actions.filter(
    action => visibleFor(action, state.entities, model, id)
  ).map(action => ({
    icon: iconFor(action),
    href: routeForAction(action, model, id, assignable_model, assignable_id)
  }))

  return {
    actions,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function iconFor(action) {
  switch(action) {
  case 'edit':
    return 'fa fa-pencil-square'
  case 'show':
    return 'fa fa-eye'
  case 'edit_assignable':
    return 'fa fa-pencil-square-o'
  }
}

function visibleFor(action, entities, model, id) {
  switch(action) {
    case 'edit_assignable':
      return true
    default:
      return true
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(TableRow)
