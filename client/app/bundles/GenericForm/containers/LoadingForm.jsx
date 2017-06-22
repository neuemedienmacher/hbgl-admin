import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import setUi from '../../../Backend/actions/setUi'
import LoadingForm from '../components/LoadingForm'
import { singularize } from '../../../lib/inflection'

const mapStateToProps = (state, ownProps) => {
  const { model, editId } = ownProps
  const uiDataLoadedFlag = `GenericForm-edit-loaded-${model}-${editId}`
  const loadedOriginalData = state.ui[uiDataLoadedFlag] || false

  return {
    uiDataLoadedFlag,
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
    object['possible-events'][nextModel][ownProps.editId] = apiResponse
    return object
  }

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData() {
      const { model, editId } = ownProps
      if (!editId) return
      const { dispatch } = dispatchProps
      const singularModel = singularize(model)

      dispatch(
        loadAjaxData(
          `${model}/${editId}`, '', model, undefined, undefined, () => {
            dispatch(setUi(stateProps.uiDataLoadedFlag, true))
          }
        )
      ),

      dispatch(
        loadAjaxData(
          `possible_events/${singularModel}/${editId}`, {}, 'possible-events',
          transformResponse, model
        )
      )
    },
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  LoadingForm
)
