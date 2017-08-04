import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import { setUiLoaded } from '../../../Backend/actions/setUi'
import LoadingForm from '../components/LoadingForm'
import { singularize } from '../../../lib/inflection'

const mapStateToProps = (state, ownProps) => {
  const { model, editId } = ownProps
  const loadedOriginalData =
    state.ui[`loaded-GenericForm-${model}-${editId}`] || false

  return {
    loadedOriginalData,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  // This response does not follow JSON API format, we need to transform it
  // manually
  const transformResponse = function(apiResponse, nextModel) {
    let object = { 'possible-events': {} }
    object['possible-events'][nextModel] = {}
    object['possible-events'][nextModel][apiResponse.id] = apiResponse
    return object
  }

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData(model = ownProps.model, editId = ownProps.editId) {
      if (!editId) return
      const { dispatch } = dispatchProps

      dispatch(
        loadAjaxData(
          `${model}/${editId}`, '', model, undefined, undefined, () => {
            dispatch(setUiLoaded(true, 'GenericForm', model, editId))
          }
        )
      )
    },

    loadPossibleEvents(model = ownProps.model, editId = ownProps.editId) {
      if (!editId) return
      const singularModel = singularize(model)

      dispatchProps.dispatch(
        loadAjaxData(
          `possible_events/${singularModel}/${editId}`, {}, 'possible-events',
          transformResponse, model
        )
      )
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  LoadingForm
)
