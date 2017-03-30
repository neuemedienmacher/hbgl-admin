import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { encode } from 'querystring'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import Pagination from '../components/Pagination'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax.indexResults
  const totalPages = resultData.meta.total_pages
  const currentPage = resultData.meta.current_page

  return {
    totalPages,
    currentPage,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  jumpToPage(event) {
    var page = null
    while(typeof page != 'number' || page < 1 || page > stateProps.totalPages) {
      page = Number(
        prompt(
          "Springe zu 1-"+stateProps.totalPages+":", stateProps.currentPage
        )
      )
    }
    gotoPage(page, ownProps)
  },

  onPageSelect(pageNumber) {
    gotoPage(pageNumber, ownProps)
  }
})

function gotoPage(page, ownProps) {
  const params = merge(clone(ownProps.params), { page })
  const href = `/${ownProps.model}?${encode(params)}`
  browserHistory.push(href)
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Pagination)
