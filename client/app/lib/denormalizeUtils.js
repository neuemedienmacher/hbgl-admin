import isArray from 'lodash/isArray'
import forEach from 'lodash/forEach'
import kebabCase from 'lodash/kebabCase'
import { pluralize } from '../lib/inflection'

export function denormalizeStateEntity(
  entities, model, id, alreadyDenormalizedModels = []
) {
  let denormalizedEntity = {}
  if (entities[model] && entities[model][id]) {
    let entity = entities[model][id]
    alreadyDenormalizedModels.push(model)
    forEach(entity, (value, key) => {
      if (isArray(value) && key.substr(-4) == '-ids' ) {
        let newModel = pluralize(key.substr(0, key.length - 4))
        // check for polymorphy (-type) and change model accordingly
        let polymorphy = entity[`${newModel}-type`]
        let entityModel = newModel
        if (polymorphy) {
          entityModel = pluralize(kebabCase(polymorphy))
        }
        if (!alreadyDenormalizedModels.includes(entityModel)){
          denormalizedEntity[newModel] = value.map(
            id => denormalizeStateEntity(entities, entityModel, id, alreadyDenormalizedModels)
          )
        }
      } else if (key.substr(-3) == '-id') {
        let newModel = key.substr(0, key.length - 3)
        // check for polymorphy (-type) and change model accordingly
        let polymorphy = entity[`${newModel}-type`]
        let entityModel = newModel
        if (polymorphy) {
          entityModel = pluralize(kebabCase(polymorphy))
        }
        if (!alreadyDenormalizedModels.includes(entityModel)){
          denormalizedEntity[newModel] =
            denormalizeStateEntity(entities, entityModel, value, alreadyDenormalizedModels)
        }
      } else {
        denormalizedEntity[key] = value
      }
    })
  }
  return denormalizedEntity
}
