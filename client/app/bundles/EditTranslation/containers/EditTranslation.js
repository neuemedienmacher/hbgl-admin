import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import { isCurrentUserAssignedToModel, currentAssignmentIdFor }
  from '../../../lib/restrictionUtils'
import EditTranslation from '../components/EditTranslation'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const model = ownProps.route.model
  let t_model = model + '_translations'
  const translation = state.entities[t_model] && state.entities[t_model][id]
  const source = state.entities[model + 's'] && state.entities[model + 's'][translation[`${model}_id`]]
  const loaded = !!translation
  const heading = `${model} translation #${id}`
  const current_assignment_id = currentAssignmentIdFor(model, translation)
  const may_edit = isCurrentUserAssignedToModel(state.entities, t_model, id)

  return {
    id,
    model,
    loaded,
    source,
    heading,
    translation,
    current_assignment_id,
    may_edit
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData() {
    const translationKey = `${stateProps.model}_translations`
    dispatchProps.dispatch(
      loadAjaxData(`${translationKey}/${stateProps.id}`, '', translationKey)
    )
  }
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(EditTranslation)
