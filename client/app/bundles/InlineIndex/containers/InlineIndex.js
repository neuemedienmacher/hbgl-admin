import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import InlineIndex from '../components/InlineIndex'
import forIn from 'lodash/forIn'
import collectionSize from 'lodash/size'

const mapStateToProps = (state, ownProps) => {
  let optional = ownProps.ident_append ? '_' + ownProps.ident_append : ''
  const model = ownProps.model
  const identifier = 'indexResults_' + model + optional
  const ui_key = 'index_' + model + optional
  const params = state.ui[ui_key] || ownProps.baseQuery

  return {
    params,
    model,
    identifier,
    ui_key
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(query = ownProps.baseQuery, nextModel = ownProps.model) {
    let optional = ownProps.ident_append ? '_' + ownProps.ident_append : ''
    dispatchProps.dispatch(
      loadAjaxData(nextModel, query, 'indexResults_' + nextModel + optional)
    )
  },

  compareParams(params1, params2) {
    if (collectionSize(params1) != collectionSize(params2)) return false
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
