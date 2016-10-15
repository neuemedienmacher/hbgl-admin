import { connect } from 'react-redux'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import setUiAction from '../../../Backend/actions/setUi'
import InlinePaginationCell from '../components/InlinePaginationCell'

const mapStateToProps = (state, ownProps) => {
  const resultData = state.ajax[ownProps.identifier]
  const activeClass =
    resultData && resultData.meta.current_page == ownProps.page ? 'active' : null

  return {
    activeClass,
    href: '#' + ownProps.identifier
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onClick(e) {
    let linkParams = merge(clone(ownProps.params), {page: ownProps.page})
    dispatch(setUiAction(ownProps.ui_key, linkParams))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(InlinePaginationCell)
