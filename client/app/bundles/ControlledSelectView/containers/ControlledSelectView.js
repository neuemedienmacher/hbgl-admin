import { connect } from 'react-redux'
import { setUi } from '../../../Backend/actions/setUi'
import ControlledSelectView from '../components/ControlledSelectView'

const mapStateToProps = (state, ownProps) => {
  const uniqIdentifier = 'controlled-select-view-' + ownProps.identifier
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

  handleSelect(event){
    if (stateProps.selectedValue != event.target.value) {
      dispatchProps.dispatch(
        setUi(stateProps.uniqIdentifier, event.target.value)
      )
    }
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  ControlledSelectView
)
