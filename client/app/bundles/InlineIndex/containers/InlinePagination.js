import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import { setUi } from '../../../Backend/actions/setUi'
import Pagination from '../../Index/components/Pagination'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax[ownProps.identifier]
  const currentPage = (resultData && resultData.meta.current_page) || 1
  const totalPages = (resultData && resultData.meta.total_pages) || 1

  return {
    currentPage,
    totalPages
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  jumpToPage(e) {
    var page = null
    while(typeof page != 'number' || page > stateProps.totalPages) {
      page = Number(
        prompt(
          "Springe zu 1-"+stateProps.totalPages+":", stateProps.currentPage
        )
      )
    }
    gotoPage(page, ownProps, dispatchProps)
  },

  onPageSelect(pageNumber) {
    gotoPage(pageNumber, ownProps, dispatchProps)
  }
})

function gotoPage(page, ownProps, dispatchProps) {
  let linkParams = merge(clone(ownProps.params), {page})
  dispatchProps.dispatch(setUi(ownProps.uiKey, linkParams))
}

export default connect(
  mapStateToProps, mapDispatchToProps, mergeProps
)(Pagination)
