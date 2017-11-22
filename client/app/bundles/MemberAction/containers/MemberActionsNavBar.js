import { connect } from 'react-redux'
import { singularize, pluralize } from '../../../lib/inflection'
import { actionsFromSettings } from '../../../lib/resourceActions'
import settings from '../../../lib/settings'
import MemberActionsNavBar from '../components/MemberActionsNavBar'

const mapStateToProps = (state, ownProps) => {
  const { model, id, location } = ownProps
  let splittedPathName = location.pathname.split('/')
  let currentAction = splittedPathName[splittedPathName.length - 1]
  let entity = state.entities[model] && state.entities[model][id]
  const viewingHash =
    state.cable.live.viewing[model] &&
    state.cable.live.viewing[model][id] || {}

  const actions =
    actionsFromSettings(pluralize(model), id, entity).map(action => {
      const viewingUsers = viewingHash[action.name]
      action.viewing =
        viewingUsers && !!viewingUsers.length && viewingUsers.length
      return action
    })

  return {
    actions,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(MemberActionsNavBar)
