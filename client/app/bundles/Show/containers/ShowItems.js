import { connect } from 'react-redux'
import toPairs from 'lodash/toPairs'
import ShowItems from '../components/ShowItems'

const mapStateToProps = (state, ownProps) => {
  // read model instance
  const model_instance = state.entities[ownProps.model] &&
    state.entities[ownProps.model][ownProps.id]
  const loaded = !!model_instance
  // read own fields and associations of current model from the state
  const field_set =  state.entities.field_sets &&
    state.entities.field_sets[ownProps.model]
  const column_names = filterFields(
    field_set && field_set.column_names || [],
    model_instance || {}
  )
  const associations = filterAssociations(
    toPairs(field_set && field_set.associations || {}),
    model_instance || {}
  )
  
  return {
    model_instance,
    associations,
    column_names,
    loaded
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

// filter Fields to only those loaded
function filterFields(fields, model_instance) {
  return fields.filter(field => model_instance[field] != undefined)
}

// filter Associations to only those loaded
function filterAssociations(assocs, model_instance) {
  return assocs.filter(assoc => model_instance[assoc[0]] != undefined)
}

export default connect(mapStateToProps, mapDispatchToProps)(ShowItems)
