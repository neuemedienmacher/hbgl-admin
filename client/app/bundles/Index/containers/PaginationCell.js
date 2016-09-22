import { connect } from 'react-redux'
import { encode } from 'querystring'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import PaginationCell from '../components/PaginationCell'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax.indexResults
  const activeClass =
    resultData.meta.current_page == ownProps.page ? 'active' : null
  const params = merge(clone(ownProps.params), { page: ownProps.page })
  const href = `/${ownProps.model}?${encode(params)}`

  return {
    activeClass,
    href
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(PaginationCell)
