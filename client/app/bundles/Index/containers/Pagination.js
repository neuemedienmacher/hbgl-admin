import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import Pagination from '../components/Pagination'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax[ownProps.identifier]
  const totalPages = resultData ? resultData.meta.total_pages : 0
  const currentPage = resultData ? resultData.meta.current_page : 1

  return {
    totalPages,
    currentPage,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  jumpToPage(event) {
    let page = null

    while (typeof page !== 'number' || page > stateProps.totalPages) {
      page = Number(
        prompt(`Springe zu 1-${stateProps.totalPages}:`, stateProps.currentPage)
      )
    }
    gotoPage(page, ownProps)
  },

  onPageSelect(pageNumber) {
    gotoPage(pageNumber, ownProps)
  },
})

/**
 * @param page
 * @param ownProps
 */
function gotoPage(page, ownProps) {
  const params = merge(clone(ownProps.params), { page })
  let href = `/?${jQuery.param(params)}`

  if (window.location.pathname.length > 1) {
    href = `/${ownProps.model}?${jQuery.param(params)}`
  }
  browserHistory.push(href)
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(Pagination)
