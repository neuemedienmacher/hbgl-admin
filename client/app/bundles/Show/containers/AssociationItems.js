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

function addValuesToAssociations(associations) {
  let new_associations = []
  associations.map(([assoc_name, assoc]) => {
    let class_name = assoc.class_name
    if(settings.index[class_name] && settings.index[class_name].member_actions){
      new_associations.push([assoc_name, assoc, `/${class_name}/`])
    }
    else{
      new_associations.push([assoc_name, assoc, false])
    }
  })
  return new_associations
}

export default connect(mapStateToProps, mapDispatchToProps)(AssociationItems)
