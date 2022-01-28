import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import pickBy from 'lodash/pickBy'
import TableHeadCell from '../components/TableHeadCell'

const mapStateToProps = (state, ownProps) => {
  const { params, field } = ownProps

  const currentDirection = params.sort_direction
  const isCurrentSortField =
    params.sort_field === field.field &&
    (field.relation === 'own' || params.sort_model == field.model)
  const linkParams = merge(clone(params), {
    sort_field: field.field,
    sort_model: field.relation === 'own' ? null : field.model,
  })

  if (isCurrentSortField) {
    linkParams.sort_direction = currentDirection == 'ASC' ? 'DESC' : 'ASC'
  }
  const href = buildLink(pickBy(linkParams), ownProps.model)
  const displayName = field.name.split('-').join(' ')

  return {
    href,
    isCurrentSortField,
    currentDirection,
    displayName,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

/**
 * @param params
 * @param model
 */
function buildLink(params, model) {
  if (window.location.pathname.length > 1) {
    return `/${model}?${jQuery.param(params)}`
  }
  return `/?${jQuery.param(params)}`
}

export default connect(mapStateToProps, mapDispatchToProps)(TableHeadCell)
