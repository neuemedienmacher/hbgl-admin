import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import AssociationItems from '../components/AssociationItems'
import kebabCase from 'lodash/kebabCase'
import upperFirst from 'lodash/upperFirst'
import camelCase from 'lodash/camelCase'
import filter from 'lodash/filter'
import { singularize, pluralize } from '../../../lib/inflection'

const mapStateToProps = (state, ownProps) => {
  const { model, modelInstance } = ownProps
  let modelFilterName = singularize(upperFirst(camelCase(model)))
  const associations = processAssociations(
    ownProps.associations || [], modelInstance, state.entities, modelFilterName
  )
  return {
    associations,
    model,
    modelInstance
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function processAssociations(associations, modelInstance, entities, model) {
  let new_associations = []
  associations.map(([assoc_name, assoc]) => {
    let className = assoc['class-name']
    let entityName = kebabCase(pluralize(className))
    let singularizedClass = kebabCase(singularize(className))
    let filter = ''
    let items = gatherAssociatedItems(
      singularizedClass, entityName, entities, modelInstance
    )
    if(assoc.key[0] && settings.index[entityName]) {
      filter = {'per_page': 15}
      filter[`filters[${assoc.key[0]}]`] = modelInstance.id
      if(assoc.key[1]){
        filter[`filters[${assoc.key[1]}]`] = model
      }
    }
    let href = ''
    if(settings.index[entityName] && settings.index[entityName].member_actions){
      href = `/${entityName}/`
    }
    if (items && items.length || filter) {
      new_associations.push([assoc_name, entityName, filter, href, items])
    }
  })
  // sort items: 1st: table-associations after belongs_to 2: by assoc_name
  return new_associations.sort((a, b) => {
    let offset = typeof(a[2]) == typeof(b[2]) ? 0 : 2
    if ( a[0] < b[0] ) return offset-1;
    else if ( a[0] > b[0]) return offset+1;
    else return offset;
  })
}

function gatherAssociatedItems(assocName, entityName, entities, modelInstance) {
  let associatedIds = []
  if (modelInstance[`${assocName}-id`]) {
    associatedIds.push(modelInstance[`${assocName}-id`])
  } else if (modelInstance[`${assocName}-ids`]) {
    associatedIds = modelInstance[`${assocName}-ids`]
  }
  if( !associatedIds.length || !entities[entityName] ) { return [] }
  return filter(entities[entityName], entity => associatedIds.includes(entity.id))
}

export default connect(mapStateToProps, mapDispatchToProps)(AssociationItems)
