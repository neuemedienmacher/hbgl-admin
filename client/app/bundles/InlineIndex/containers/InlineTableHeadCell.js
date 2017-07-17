import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import forEach from 'lodash/forEach'
import { setUi } from '../../../Backend/actions/setUi'
import InlineTableHeadCell from '../components/InlineTableHeadCell'

const mapStateToProps = (state, ownProps) => {
  const { params, field, identifier } = ownProps

  const currentDirection = params.sort_direction
  const isCurrentSortField = _isCurrentSortField(params, field)
  const displayName = field.name.split('_').join(' ')
  const href = '#' + identifier

  return {
    isCurrentSortField,
    currentDirection,
    displayName,
    href
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onClick(e) {
    let params = ownProps.params
    let field = ownProps.field
    // reset params and re-fill them, if required
    let tempParams = merge(clone(params), {sort_field: field.field, sort_model: null})
    if(field.relation != 'own'){
      tempParams = merge(tempParams, {sort_model: field.model})
    }
    if (_isCurrentSortField(params, field)) {
      tempParams.sort_direction = params.sort_direction == 'ASC' ? 'DESC' : 'ASC'
    }
    // finalParams by rejecting null values to keep the params clean
    let finalParams = {}
    forEach(tempParams, function(value, key) {
      if(value != null) { finalParams[key] = value }
    });
    dispatch(setUi(ownProps.uiKey, finalParams))
  }
})

function _isCurrentSortField(params, field) {
  return params.sort_field == field.field &&
    (field.relation == 'own' || params.sort_model == field.model)
}

export default connect(mapStateToProps, mapDispatchToProps)(InlineTableHeadCell)
