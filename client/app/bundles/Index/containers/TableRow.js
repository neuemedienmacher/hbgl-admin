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
  const actions = settings.index[model].member_actions.map(action => ({
    icon: iconFor(action),
    href: routeForAction(action, model, id, assignable_model, assignable_id),
    reactLink: action != 'assign_and_edit_assignable',
    visible: visibleFor(action, state.entities, model, id)
  }))

  return {
    actions,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function iconFor(action) {
  switch(action) {
  case 'edit':
    return 'fui-new'
  case 'show':
    return 'fui-eye'
  case 'edit_assignable':
    return 'fui-new'
  case 'assign_and_edit_assignable':
    return 'fui-lock'
  }
}

function visibleFor(action, entities, model, id) {
  switch(action) {
    case 'edit_assignable':
      return isCurrentUserAssignedToModel(entities, model, id)
    case 'assign_and_edit_assignable':
      return isTeamOfCurrentUserAssignedToModel(entities, model, id) &&
        !isCurrentUserAssignedToModel(entities, model, id)
    default:
      return true
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(TableRow)
