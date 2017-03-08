import { connect } from 'react-redux'
import range from 'lodash/range'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import setUiAction from '../../../Backend/actions/setUi'
import InlinePagination from '../components/InlinePagination'

const mapStateToProps = (state, ownProps) => {
  let resultData = state.ajax[ownProps.identifier]
  const pages = resultData ? range(1, resultData.meta.total_pages + 1) : [1]
  const current_page = resultData && resultData.meta.current_page ? resultData.meta.current_page : 1
  const paginationSize = 3
  const previousPageHref =
    resultData && resultData.links.previous ? '#' + ownProps.identifier: ''
  const nextPageHref =
    resultData && resultData.links.next ? '#' + ownProps.identifier: ''

  const pageScope = []
  for (var i = paginationSize + 1; i > 0; i--) {
    if (current_page >= i){
      pageScope.push(pages[current_page - i])
    }
  }
  for (var i = 0; i < paginationSize; i++) {
    if (current_page + i < pages.length ){
      pageScope.push(pages[current_page + i])
    }
  }

  return {
    pages,
    previousPageHref,
    nextPageHref,
    pageScope,
    current_page,
    paginationSize
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
    dispatch,
  previousPage(e) {
    let params = ownProps.params
    let current_page = params.page || 1
    let linkParams = merge(clone(params), {page: current_page - 1})
    dispatch(setUiAction(ownProps.uiKey, linkParams))
  },
  nextPage(e) {
    let params = ownProps.params
    let current_page = params.page || 1
    let linkParams = merge(clone(params), {page: current_page + 1})
    dispatch(setUiAction(ownProps.uiKey, linkParams))
  }
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  jumpToPage(e) {
    let params = ownProps.params
    let current_page = params.page || 1
    var page = null;
    while (stateProps.pages[page-1] == null) {
      page = prompt("Springe zu 1-"+stateProps.pages.length+":", current_page);
    }
    let linkParams = merge(clone(params), {page})
    dispatchProps.dispatch(setUiAction(ownProps.uiKey, linkParams))
  },
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(InlinePagination)
