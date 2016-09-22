import { connect } from 'react-redux'
import range from 'lodash/range'
import Pagination from '../components/Pagination'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax.indexResults
  const pages = range(1, resultData.meta.total_pages + 1)

  // Remove the /api/v1 part from links to make it a ui route
  let previousPageHref = resultData.links.previous || ''
  if (previousPageHref) previousPageHref = previousPageHref.substr(7)
  let nextPageHref = resultData.links.next || ''
  if (nextPageHref) nextPageHref = nextPageHref.substr(7)

  return {
    pages,
    previousPageHref,
    nextPageHref,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(Pagination)
