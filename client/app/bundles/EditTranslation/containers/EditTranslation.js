import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import EditTranslation from '../components/EditTranslation'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const model = ownProps.route.model
  let t_model = model + '-translations'
  const translation = state.entities[t_model] && state.entities[t_model][id]
  const source = state.entities[model + 's'] && translation &&
    state.entities[model + 's'][translation[`${model}-id`]]
  const loaded = !!translation
  const heading = `${model} translation #${id}`

  return {
    id,
    model,
    loaded,
    source,
    heading,
    translation,
    t_model
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
    const translationKey = `${stateProps.model}-translations`
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
