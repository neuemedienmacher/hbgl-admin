import { connect } from 'react-redux'
import { actionsFromSettings } from '../../../lib/resourceActions'
// import { isTeamOfCurrentUserAssignedToModel, isCurrentUserAssignedToModel }
//   from '../../../lib/restrictionUtils'
import ActionList from '../components/ActionList'

const mapStateToProps = (state, ownProps) => {
  let model = ownProps.model
  let id = ownProps.id

  const entity =
    ownProps.entity || state.entities[model] && state.entities[model][id]

  return {
    actions: actionsFromSettings(model, id, entity)
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(ActionList)
