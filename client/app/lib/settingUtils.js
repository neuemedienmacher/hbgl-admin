import forIn from 'lodash/forIn'
import flatten from 'lodash/flatten'

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
