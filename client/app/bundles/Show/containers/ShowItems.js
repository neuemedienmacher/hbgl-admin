import { connect } from 'react-redux'
import toPairs from 'lodash/toPairs'
import kebabCase from 'lodash/kebabCase'
import ShowItems from '../components/ShowItems'
import { pluralize } from '../../../lib/inflection'

const mapStateToProps = (state, ownProps) => {
  // read model instance
  const modelInstance = state.entities[ownProps.model] &&
    state.entities[ownProps.model][ownProps.id]
  const loaded = !!modelInstance
  // read own fields and associations of current model from the state
  const fieldSet =  state.entities['field-sets'] &&
    state.entities['field-sets'][ownProps.model]
  const columnNames = filterFields(
    fieldSet && fieldSet['columns'] || [],
    modelInstance || {}
  )
  const associations = toPairs(fieldSet && fieldSet.associations || {})
  // console.log('filtered:', associations)
  return {
    modelInstance,
    associations,
    columnNames,
    loaded,
    model: ownProps.model
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function filterFields(fields, modelInstance) {
  let fieldNames = fields.map(field => field.name)
  return fieldNames.filter(field => modelInstance[field] != undefined )
}

export default connect(mapStateToProps, mapDispatchToProps)(ShowItems)
