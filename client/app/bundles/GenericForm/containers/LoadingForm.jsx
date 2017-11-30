import { connect } from 'react-redux'
// import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import LoadingForm from '../components/LoadingForm'
import { handleError } from '../../../lib/ajaxRedirectHandler'
import { singularize } from '../../../lib/inflection'

const mapStateToProps = (state, ownProps) => {
  const { model, id } = ownProps
  const loadedOriginalData =
    state.ui[`loaded-GenericForm-${model}-${id}`] || false

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

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    // loadData(model = ownProps.model, id = ownProps.id) {
    //   if (!id) return
    //   const { dispatch } = dispatchProps
    //
    //   dispatch(
    //     loadAjaxData(
    //       `${model}/${id}`, '', model, { onSuccess:
    //         () => { dispatch(setUiLoaded(true, 'GenericForm', model, id)) },
    //         onError: handleError(model, dispatchProps.dispatch)
    //       }
    //     )
    //   )
    // },
    //
    // loadPossibleEvents(model = ownProps.model, id = ownProps.id) {
    //   if (!id) return
    //   const singularModel = singularize(model)
    //
    // }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  LoadingForm
)
