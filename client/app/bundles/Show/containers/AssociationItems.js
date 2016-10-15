import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import AssociationItems from '../components/AssociationItems'

const mapStateToProps = (state, ownProps) => {
  const model_instance = ownProps.model_instance
  const associations = addValuesToAssociations(ownProps.associations || [], model_instance)

  return {
    model_instance,
    associations
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function addValuesToAssociations(associations, model_instance) {
  let new_associations = []
  associations.map(([assoc_name, assoc]) => {
    let class_name = assoc.class_name
    let filter = {'per_page': 15}
    filter[`filter[${assoc.key}]`] = model_instance.id
    let identifier = '_' + assoc_name
    new_associations.push([assoc_name, class_name, filter, identifier])
  })
  return new_associations
}

export default connect(mapStateToProps, mapDispatchToProps)(AssociationItems)
