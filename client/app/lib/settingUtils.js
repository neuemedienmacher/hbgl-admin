import forIn from 'lodash/forIn'
import flatten from 'lodash/flatten'
import clone from 'lodash/clone'

export function analyzeFields(rawFields, model) {
  return flatten(rawFields.map(rawField => {
    if (typeof rawField == 'string') {
      return { name: rawField, relation: 'own', model: model, field: rawField }
    } else {
      let associations = []
      forIn(rawField, (associatedFields, association) => {
        if(typeof associatedFields != 'string'){
          for (let associatedField of associatedFields) {
            associations.push({
              name: `${association} ${associatedField}`,
              relation: 'association',
              model: association,
              field: associatedField
            })
          }
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
      let relationshipAttributes = results.included.filter(included => {
        return included.id == relationshipData.data.id &&
          included.type == relationshipData.data.type
      })[0]
      denormalized[name] = relationshipAttributes.attributes
    })

    return denormalized
  })
}
