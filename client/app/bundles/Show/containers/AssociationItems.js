import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import AssociationItems from '../components/AssociationItems'

const mapStateToProps = (state, ownProps) => {
  const modelInstance = ownProps.modelInstance
  const associations =
    processAssociations(ownProps.associations || [], modelInstance)
  return {
    modelInstance,
    associations
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function processAssociations(associations, modelInstance) {
  let new_associations = []
  associations.map(([assoc_name, assoc]) => {
    let className = assoc['class-name']
    let filter = ''
    if(assoc.key) {
      filter = {'per_page': 15}
      filter[`filter[${assoc.key}]`] = modelInstance.id
    }
    let href = ''
    if(settings.index[className] && settings.index[className].member_actions){
      href = `/${className}/`
    }
    new_associations.push([assoc_name, className, filter, href])
  })
  return new_associations
}

export default connect(mapStateToProps, mapDispatchToProps)(AssociationItems)
