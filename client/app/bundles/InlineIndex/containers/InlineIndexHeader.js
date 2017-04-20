import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import pickBy from 'lodash/pickBy'
import toPairs from 'lodash/toPairs'
import setUiAction from '../../../Backend/actions/setUi'
import IndexHeader from '../../Index/components/IndexHeader'

const mapStateToProps = (state, ownProps) => {
  const filters = toPairs(
    pickBy(ownProps.params, (value, key) =>
      key.substr(0, 7) == 'filters' &&
        ownProps.lockedParams.hasOwnProperty(key) == false
    )
  )
  let ownParams = pickBy(ownProps.params, (value, key) => {
      return ownProps.lockedParams.hasOwnProperty(key) == false
    }
  )
  const plusButtonDisabled = ownParams.hasOwnProperty('filters[id]')
  // re-use IndexHeader container but don't support routes
  const routes = []
  const uiKey = ownProps.uiKey

  return {
    params: ownParams,
    lockedParams: ownProps.lockedParams,
    filters,
    plusButtonDisabled,
    routes,
    uiKey
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  onQueryChange(event) {
    let params = merge(clone(stateProps.params), { query: event.target.value })
    dispatchProps.dispatch(setUiAction(stateProps.uiKey, params))
  },

  onPlusClick(event) {
    let params = clone(stateProps.params)
    if (params['filters[id]']) return // ID filtered - other filters not needed
    merge(params, { 'filters[id]': '' })
    dispatchProps.dispatch(setUiAction(stateProps.uiKey, params))
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  IndexHeader
)
