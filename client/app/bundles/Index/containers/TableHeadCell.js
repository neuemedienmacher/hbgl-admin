import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import pickBy from 'lodash/pickBy'
import { encode } from 'querystring'
import TableHeadCell from '../components/TableHeadCell'

const mapStateToProps = (state, ownProps) => {
  const { params, field } = ownProps

  const currentDirection = params.sort_direction
  const isCurrentSortField = (
    params.sort_field == field.field &&
      (field.relation == 'own' || params.sort_model == field.model)
  )
  let linkParams = merge(clone(params), {
    sort_field: field.field,
    sort_model: (field.relation == 'own' ? null : field.model)
  })
  if (isCurrentSortField) {
    linkParams.sort_direction = currentDirection == 'ASC' ? 'DESC' : 'ASC'
  }
  let href = `/${ownProps.model}?${encode(pickBy(linkParams))}`

  const displayName = field.name.split('-').join(' ')

  return {
    href,
    isCurrentSortField,
    currentDirection,
    displayName,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(TableHeadCell)
