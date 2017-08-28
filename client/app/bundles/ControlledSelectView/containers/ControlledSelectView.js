import { connect } from 'react-redux'
import { setUi } from '../../../Backend/actions/setUi'
import ControlledSelectView from '../components/ControlledSelectView'
import { browserHistory } from 'react-router'
import { encode } from 'querystring'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'

const mapStateToProps = (state, ownProps) => {
  const uniqIdentifier = 'controlled-select-view-' + ownProps.identifier
  // selectedTab priority: ui-state > optional default > 0
  let selectedValue = state.ui[uniqIdentifier]
  if (selectedValue === undefined) selectedValue = ownProps.startIndex;
  if (selectedValue === undefined) selectedValue = 0;
  const params = ownProps.params

  return {
    uniqIdentifier,
    selectedValue,
    params
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
      let params = stateProps.params
      params['filters[receiver-team-id]'] = event.target.value
      dispatchProps.dispatch(
        loadAjaxData('assignments', params, 'indexResults')
      )
      browserHistory.replace(`/?${jQuery.param(params)}`)
    }
  },
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  ControlledSelectView
)
