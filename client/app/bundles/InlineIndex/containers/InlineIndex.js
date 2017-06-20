import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import InlineIndex from '../components/InlineIndex'
import forIn from 'lodash/forIn'
import size from 'lodash/size'
import merge from 'lodash/merge'
import clone from 'lodash/clone'

const mapStateToProps = (state, ownProps) => {
  let optional =
    ownProps.identifier_addition ? '_' + ownProps.identifier_addition : ''
  const model = ownProps.model
  const identifier = 'indexResults_' + model + optional
  const uiKey = 'index_' + model + optional
  const params =
    merge(
      clone(ownProps.optionalParams),
      merge(clone(state.ui[uiKey]), ownProps.lockedParams)
    )
  const count = state.ajax[identifier] ? state.ajax[identifier].meta.total_entries : 0

  return {
    params,
    lockedParams: ownProps.lockedParams,
    model,
    identifier,
    uiKey,
    count
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(query = merge(clone(ownProps.optionalParams), ownProps.lockedParams), nextModel = ownProps.model) {
    let optional =
      ownProps.identifier_addition ? '_' + ownProps.identifier_addition : ''
    dispatchProps.dispatch(
      loadAjaxData(nextModel, query, 'indexResults_' + nextModel + optional)
    )
  },

  equalParams(params1, params2) {
    if (size(params1) != size(params2)) return false
    let isSame = true
    forIn(params1, (value, key) => {
      if(!isSame || params2[key] != value) {
        isSame = false
      }
    })
    return isSame
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(InlineIndex)
