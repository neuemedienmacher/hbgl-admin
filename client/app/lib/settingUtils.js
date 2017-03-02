import forIn from 'lodash/forIn'
import flatten from 'lodash/flatten'
import clone from 'lodash/clone'
import isArray from 'lodash/isArray'

export function analyzeFields(rawFields, model) {
  return flatten(rawFields.map(rawField => {
    if (typeof rawField == 'string') {
      return { name: rawField, relation: 'own', model: model, field: rawField }
    } else {
      let associations = []
      forIn(rawField, (associatedFields, association) => {
        for (let associatedField of associatedFields) {
          associations.push({
            name: `${association} ${associatedField}`,
            relation: 'association',
            model: association,
            field: associatedField
          })
        }
      })
      return associations
    }
  }))
}

export function denormalizeIndexResults(results) {
  return results.data.map(datum => {
    // get base attributes
    let denormalized = clone(datum.attributes)
    denormalized.id = datum.id

    // denormalize JSON API relationship information
    forIn(datum.relationships, (relationshipData, name) => {
      let denormalized_relationship
      // iterate relation if it's an array and add array of attributes
      if (isArray(relationshipData.data)) {
        denormalized_relationship = results.included.filter(included => {
          return relationshipData.data.filter(relation => {
            return compareIDAndType(included, relation)
          }).length > 0
        }).map( foundRelation => { return foundRelation.attributes } )
      } else { // otherwise just add the attributes of the single item
        denormalized_relationship = results.included.filter(included => {
          return compareIDAndType(included, relationshipData.data)
        })[0].attributes
      }
      denormalized[name] = denormalized_relationship
    })
    return denormalized
  })
}

function compareIDAndType(item1, item2) {
  return item1.id == item2.id && item1.type == item2.type
}
