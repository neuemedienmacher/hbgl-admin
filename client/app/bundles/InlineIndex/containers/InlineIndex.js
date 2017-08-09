import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import InlineIndex from '../components/InlineIndex'
import forIn from 'lodash/forIn'
import size from 'lodash/size'
import merge from 'lodash/merge'
import clone from 'lodash/clone'

const mapStateToProps = (state, ownProps) => {
  let optional =
    ownProps.identifierAddition ? '_' + ownProps.identifierAddition : ''
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
      ownProps.identifierAddition ? '_' + ownProps.identifierAddition : ''
    dispatchProps.dispatch(
      loadAjaxData(nextModel, query, 'indexResults_' + nextModel + optional)
    )
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(InlineIndex)
