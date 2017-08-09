import forIn from 'lodash/forIn'
import flatten from 'lodash/flatten'
import clone from 'lodash/clone'
import isPlainObject from 'lodash/isPlainObject'
// import isArray from 'lodash/isArray'

export function analyzeFields(rawFields, model) {
  return flatten(rawFields.map(rawField => {
    if (typeof rawField == 'string') {
      return { name: rawField, relation: 'own', model: model, field: rawField }
    } else { // is object
      return _analyzeAssociationField(rawField)
    }
  }))
}

function _analyzeAssociationField(associationObject, heritage = []) {
  let associations = []
  forIn(associationObject, (associatedFields, association) => {
    let nestedHeritage = clone(heritage)
    nestedHeritage.push(association)
    if (isPlainObject(associatedFields)) {
      associations.push(
        _analyzeAssociationField(associatedFields, nestedHeritage)
      )
    } else { // is array
      for (let associatedField of associatedFields) {
        associations.push({
            name: `${nestedHeritage.join(' ')} ${associatedField}`,
          relation: 'association',
          model: nestedHeritage.join('.'),
          field: associatedField
        })
      }
    }
  })
  return flatten(associations)
}

// deprecated!
// export function denormalizeIndexResults(results) {
//   // console.log(results)
//   return results.data.map(datum => {
//     // get base attributes
//     let denormalized = clone(datum.attributes)
//     denormalized.id = datum.id
//
//     // console.log(datum)
//     // denormalize JSON API relationship information
//     forIn(datum.relationships, (relationshipData, name) => {
//       // console.log(name)
//       if (relationshipData && relationshipData.data ) {
//         // console.log(relationshipData)
//         let denormalized_relationship
//         // iterate relation if it's an array and add array of attributes
//         if (isArray(relationshipData.data)) {
//           denormalized_relationship = results.included.filter(included => {
//             return relationshipData.data.filter(relation => {
//               return compareIDAndType(included, relation)
//             }).length > 0
//           }).map( foundRelation => foundRelation.attributes )
//         } else { // otherwise just add the attributes of the single item
//           denormalized_relationship = results.included.filter(included => {
//             return compareIDAndType(included, relationshipData.data)
//           })[0].attributes
//         }
//         denormalized[name] = denormalized_relationship
//       }
//     })
//     return denormalized
//   })
// }
//
// function compareIDAndType(item1, item2) {
//   return item1.id == item2.id && item1.type == item2.type
// }
