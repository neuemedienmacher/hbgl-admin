import { connect } from 'react-redux'
import toPairs from 'lodash/toPairs'
import ShowItems from '../components/ShowItems'

const mapStateToProps = (state, ownProps) => {
  // read model instance
  const modelInstance = state.entities[ownProps.model] &&
    state.entities[ownProps.model][ownProps.id]
  const loaded = !!modelInstance
  // read own fields and associations of current model from the state
  const fieldSet =  state.entities['field-sets'] &&
    state.entities['field-sets'][ownProps.model]
  const columnNames = filterFields(
    fieldSet && fieldSet['column-names'] || [],
    modelInstance || {}
  )
  const associations = filterAssociations(
    toPairs(fieldSet && fieldSet.associations || {}),
    modelInstance || {}
  )

  return {
    modelInstance,
    associations,
    columnNames,
    loaded
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function filterFields(fields, modelInstance) {
  return fields.filter(field => modelInstance[field] != undefined)
}

function filterAssociations(assocs, modelInstance) {
  return assocs.filter(assoc => modelInstance[assoc[0]] != undefined)
}

export default connect(mapStateToProps, mapDispatchToProps)(ShowItems)
