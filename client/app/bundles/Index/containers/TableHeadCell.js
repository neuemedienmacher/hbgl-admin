import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import pickBy from 'lodash/pickBy'
import { encode } from 'querystring'
import TableHeadCell from '../components/TableHeadCell'

const mapStateToProps = (state, ownProps) => {
  const currentDirection = ownProps.params.direction
  const isCurrentSortField = ownProps.params.sort == ownProps.field

  let params = merge(clone(ownProps.params), {sort: ownProps.field})
  if (isCurrentSortField) {
    params.direction = currentDirection == 'ASC' ? 'DESC' : 'ASC'
  }
  let href = `/${ownProps.model}?${encode(pickBy(params))}`

  return {
    href,
    isCurrentSortField,
    currentDirection,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(TableHeadCell)
