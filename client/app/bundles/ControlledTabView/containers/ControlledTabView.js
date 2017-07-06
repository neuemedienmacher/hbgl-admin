import { connect } from 'react-redux'
import { setUi } from '../../../Backend/actions/setUi'
import ControlledTabView from '../components/ControlledTabView'

const mapStateToProps = (state, ownProps) => {
  const uniqIdentifier = 'controlled-tab-view-' + ownProps.identifier
  // selectedTab priority: ui-state > optional default > 0
  let selectedTab = state.ui[uniqIdentifier]
  if (selectedTab === undefined) selectedTab = ownProps.startIndex;
  if (selectedTab === undefined) selectedTab = 0;

  return {
    uniqIdentifier,
    selectedTab
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  handleSelect(e){
    if (stateProps.selectedTab != e) {
      dispatchProps.dispatch(setUi(stateProps.uniqIdentifier, e))
    }
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  ControlledTabView
)
