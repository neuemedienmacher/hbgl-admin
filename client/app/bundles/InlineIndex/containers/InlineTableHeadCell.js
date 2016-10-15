import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import setUiAction from '../../../Backend/actions/setUi'
import InlineTableHeadCell from '../components/InlineTableHeadCell'

const mapStateToProps = (state, ownProps) => {
  const { params, field, identifier } = ownProps

  const currentDirection = params.sort_direction
  const isCurrentSortField = _isCurrentSortField(params, field)
  const displayName = field.name.split('_').join(' ')

  return {
    isCurrentSortField,
    currentDirection,
    displayName,
    href: '#' + identifier
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onClick(e) {
    let params = ownProps.params
    let field = ownProps.field
    let linkParams = merge(clone(params), {sort_field: field.field})
    // TODO: sort_model might cause problems..
    if(field.relation != 'own'){
      linkParams = merge(linkParams,{sort_model: field.model})
    }
    if (_isCurrentSortField(params, field)) {
      linkParams.sort_direction = params.sort_direction == 'ASC' ? 'DESC' : 'ASC'
    }
    dispatch(setUiAction(ownProps.ui_key, linkParams))
  }
})

function _isCurrentSortField(params, field) {
  return params.sort_field == field.field && (field.relation == 'own' || params.sort_model == field.model)
}

export default connect(mapStateToProps, mapDispatchToProps)(InlineTableHeadCell)
