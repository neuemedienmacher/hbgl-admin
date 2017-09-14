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
  const heading = headingFor(model, id, currentAction)
  const actions = actionsFromSettings(pluralize(model), id, entity)

  return {
    actions,
    heading
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

function headingFor(model, id, action) {
  let singularModelName = singularize(model)
  if (action == 'edit'){
    return `${singularModelName}#${id} bearbeiten`
  } else if ( action == 'delete') {
    return  `${singularModelName}#${id} löschen`
  } else if ( action == 'new') {
    return  `Neue ${singularModelName} anlegen`
  } else {
    return `Details für ${singularModelName}#${id}`
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(MemberActionsNavBar)
