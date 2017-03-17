import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import pickBy from 'lodash/pickBy'
import toPairs from 'lodash/toPairs'
import setUiAction from '../../../Backend/actions/setUi'
import IndexHeader from '../../Index/components/IndexHeader'

const mapStateToProps = (state, ownProps) => {
  const filters = toPairs(
    pickBy(ownProps.params, (value, key) => key.substr(0, 7) == 'filters')
  )
  const plusButtonDisabled = ownProps.params.hasOwnProperty('filters[id]')
  // re-use IndexHeader container but don't support routes
  const routes = []
  const uiKey = ownProps.uiKey

  return {
    ...ownProps.params,
    filters,
    plusButtonDisabled,
    routes,
    uiKey
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onQueryChange(event) {
    let params = merge(clone(ownProps.params), { query: event.target.value })
    dispatch(setUiAction(ownProps.uiKey, params))
  },

  onPlusClick(event) {
    let params = clone(ownProps.params)
    if (params['filters[id]']) return // ID filtered - other filters not needed
    merge(params, { 'filters[id]': '' })
    dispatch(setUiAction(ownProps.uiKey, params))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeader)
