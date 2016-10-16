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
    let filter = ''
    if(assoc.key) {
      filter = {'per_page': 15}
      filter[`filter[${assoc.key}]`] = model_instance.id
    }
    let href = ''
    if(settings.index[class_name] && settings.index[class_name].member_actions){
      href = `/${class_name}/`
    }
    new_associations.push([assoc_name, class_name, filter, href])
  })
  return new_associations
}

export default connect(mapStateToProps, mapDispatchToProps)(AssociationItems)
