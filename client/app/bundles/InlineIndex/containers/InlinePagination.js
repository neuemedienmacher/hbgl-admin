import { connect } from 'react-redux'
import range from 'lodash/range'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import setUiAction from '../../../Backend/actions/setUi'
import InlinePagination from '../components/InlinePagination'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax[ownProps.identifier]
  const pages = resultData ? range(1, resultData.meta.total_pages + 1) : [1]

  let previousPageHref =
    resultData && resultData.links.previous ? '#' + ownProps.identifier: ''
  let nextPageHref =
    resultData && resultData.links.next ? '#' + ownProps.identifier: ''

  return {
    pages,
    previousPageHref,
    nextPageHref,
    ui_key: ownProps.ui_key
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  previousPage(e) {
    let params = ownProps.params
    let current_page = params.page || 1
    let linkParams = merge(clone(params), {page: current_page - 1})
    dispatch(setUiAction(ownProps.ui_key, linkParams))
  },
  nextPage(e) {
    let params = ownProps.params
    let current_page = params.page || 1
    let linkParams = merge(clone(params), {page: current_page + 1})
    dispatch(setUiAction(ownProps.ui_key, linkParams))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(InlinePagination)
