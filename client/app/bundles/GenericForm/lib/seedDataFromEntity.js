import { singularize } from '../../../lib/inflection'

export default function seedDataFromEntity(
  entity, formObjectClass, modifySeedData
) {
  let fields = formObjectClass.genericFormDefaults || {}
  if (!entity) return fields

  for (let property of formObjectClass.properties) {
    fields[property] = entity[property]
  }

  for (let submodel of formObjectClass.submodels) {
    let submodelKey
    if (
      formObjectClass.submodelConfig[submodel].relationship == 'oneToOne'
    ) {
      submodelKey = submodel + '-id'
      if (!entity[submodelKey]) continue
      fields[submodel] = String(entity[submodelKey])
    } else {
      submodelKey = singularize(submodel) + '-ids'
      if (!entity[submodelKey]) continue
      fields[submodel] = entity[submodelKey].map(e => String(e))
    }
  }

  if (modifySeedData)
    fields = modifySeedData(fields, entity, formObjectClass)

  return fields
}
