import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import setUi from '../../../Backend/actions/setUi'
import LoadingForm from '../components/LoadingForm'

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

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData() {
    const { model, editId } = ownProps
    if (!editId) return
    const { dispatch } = dispatchProps

    dispatch(
      loadAjaxData(
        `${model}/${editId}`, '', model, undefined, undefined, () => {
          dispatch(setUi(stateProps.uiDataLoadedFlag, true))
        }
      )
    )
  },
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  LoadingForm
)
