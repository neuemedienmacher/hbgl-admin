import isArray from 'lodash/isArray'
import forEach from 'lodash/forEach'
import kebabCase from 'lodash/kebabCase'
import { pluralize } from '../lib/inflection'
import settings from '../lib/settings'

export function denormalizeStateEntity(
  entities, model, id, depth = 0
) {
  if (depth >= 3) return null // recursive escape condition
  let denormalizedEntity = {}
  let entity = entities[model] && entities[model][id]
  if (entity) {
    forEach(entity, (value, key) => {
      if (isArray(value) && key.substr(-4) == '-ids' ) {
        let newModel = pluralize(key.substr(0, key.length - 4))
        let entityModel =
          entityModelForAssociation(entity, newModel, newModel, model)
        denormalizedEntity[newModel] = value.map(id =>
          denormalizeStateEntity(entities, entityModel, id, depth + 1)
        )
      } else if (key.substr(-3) == '-id') {
        let newModel = key.substr(0, key.length - 3)
        let entityModel =
          entityModelForAssociation(entity, newModel, pluralize(newModel), model)
        denormalizedEntity[newModel] =
          denormalizeStateEntity(entities, entityModel, value, depth + 1)
      }
      denormalizedEntity[key] = value
    })
    return denormalizedEntity
  } else {
    return null
  }
}

function entityModelForAssociation(entity, newModel, entityModel, model){
  // check for renamed model via mapping
  if (associationModelMapping(newModel, settings, model))
    return associationModelMapping(newModel, settings, model)

  // check for polymorphy (-type)
  let polymorphy = entity[`${newModel}-type`]
  if (polymorphy) {
    return pluralize(kebabCase(polymorphy))
  }

  // else return original
  return entityModel
}

function associationModelMapping(newModel, settings, model){
  let associationModel = null
  let associationMapping = settings.index[model].association_model_mapping
  if (associationMapping && associationMapping[newModel]) {
    associationModel = associationMapping[newModel]
  }
  return associationModel
}
