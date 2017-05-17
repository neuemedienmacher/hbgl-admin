import { connect } from 'react-redux'
import setUiAction from '../../../Backend/actions/setUi'
import ControlledSelectView from '../components/ControlledSelectView'

const mapStateToProps = (state, ownProps) => {
  const uniqIdentifier = 'controlled-select-view-' + ownProps.identifier
  // selectedTab priority: ui-state > optional default > 0
  let selectedValue = state.ui[uniqIdentifier]
  if (selectedValue === undefined) selectedValue = ownProps.startIndex;
  if (selectedValue === undefined) selectedValue = 0;

  return {
    uniqIdentifier,
    selectedValue
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
    if (stateProps.selectedValue != e.target.value) {
      dispatchProps.dispatch(
        setUiAction(stateProps.uniqIdentifier, e.target.value)
      )
    }
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  ControlledSelectView
)
