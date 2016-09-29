import { connect } from 'react-redux'
import IndexHeaderFilterOption from '../components/IndexHeaderFilterOption'

const mapStateToProps = (state, ownProps) => {
  const { field } = ownProps
  const value =
    (field.relation == 'own') ? field.field : `${field.model}s.${field.field}` // TODO: Less dumb pluralization
  const displayName =
    (field.relation == 'own') ? field.field : `${field.model} ${field.field}`

  return {
    value,
    displayName,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeaderFilterOption)
