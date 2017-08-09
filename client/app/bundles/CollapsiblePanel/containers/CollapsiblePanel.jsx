import { connect } from 'react-redux'
import { setUi } from '../../../Backend/actions/setUi'
import CollapsiblePanel from '../components/CollapsiblePanel'

const mapStateToProps = (state, ownProps) => {
  const uiKey = state.ui.collapsiblePanel
  const open =
    uiKey && uiKey[ownProps.identifier] !== undefined ? uiKey[ownProps.identifier] : ownProps.visible

  return {
    open,
    uiKey,
    title: ownProps.title
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  onClick(e) {
    let uiSettings = stateProps.uiKey || {}
    uiSettings[ownProps.identifier] = !stateProps.open
    dispatchProps.dispatch(setUi('collapsiblePanel', uiSettings))
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  CollapsiblePanel
)
