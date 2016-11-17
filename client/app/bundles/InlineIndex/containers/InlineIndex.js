import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import InlineIndex from '../components/InlineIndex'
import forIn from 'lodash/forIn'
import size from 'lodash/size'

const mapStateToProps = (state, ownProps) => {
  let optional =
    ownProps.identifier_addition ? '_' + ownProps.identifier_addition : ''
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
