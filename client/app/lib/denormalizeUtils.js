import isArray from 'lodash/isArray'
import forEach from 'lodash/forEach'
import kebabCase from 'lodash/kebabCase'
import { pluralize } from '../lib/inflection'

export function denormalizeStateEntity(
  entities, model, id, denormalizedModels = []
) {
  let denormalizedEntity = {}

  if (entities[model] && entities[model][id]) {
    denormalizedModels.push(model)
    forEach(entity, (value, key) => {
      if (isArray(value) && key.substr(-4) == '-ids' ) {
        let newModel = pluralize(key.substr(0, key.length - 4))
        let entityModel =
          entityModelForAssociation(entity, newModel, newModel)
        if (!denormalizedModels.includes(entityModel)){
          denormalizedEntity[newModel] = value.map(id =>
            denormalizeStateEntity(entities, entityModel, id, denormalizedModels)
          )
        }
      } else if (key.substr(-3) == '-id') {
        let newModel = key.substr(0, key.length - 3)
        let entityModel =
          entityModelForAssociation(entity, newModel, pluralize(newModel))
        if (!denormalizedModels.includes(entityModel)) {
          denormalizedEntity[newModel] =
            denormalizeStateEntity(entities, entityModel, value, denormalizedModels)
        }
      } else {
        denormalizedEntity[key] = value
      }
    })
  }
  return denormalizedEntity
}

function entityModelForAssociation(entity, newModel, startModel){
  // check for polymorphy (-type) and change model accordingly
  let polymorphy = entity[`${newModel}-type`]
  let entityModel = startModel
  if (polymorphy) {
    entityModel = pluralize(kebabCase(polymorphy))
  }
  return entityModel
}
