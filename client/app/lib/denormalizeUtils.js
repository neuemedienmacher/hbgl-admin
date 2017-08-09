import isArray from 'lodash/isArray'
import forEach from 'lodash/forEach'
import kebabCase from 'lodash/kebabCase'
import { pluralize } from '../lib/inflection'

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
          entityModelForAssociation(entity, newModel, newModel)
        denormalizedEntity[newModel] = value.map(id =>
          denormalizeStateEntity(entities, entityModel, id, depth + 1)
        )
      } else if (key.substr(-3) == '-id') {
        let newModel = key.substr(0, key.length - 3)
        let entityModel =
          entityModelForAssociation(entity, newModel, pluralize(newModel))
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

function entityModelForAssociation(entity, newModel, entityModel){
  // check for renamed model via mapping
  if (associationModelMapping[newModel])
    return associationModelMapping[newModel]

  // check for polymorphy (-type)
  let polymorphy = entity[`${newModel}-type`]
  if (polymorphy) {
    return pluralize(kebabCase(polymorphy))
  }

  // else return original
  return entityModel
}

const associationModelMapping = {
  'current-assignment': 'assignments',
  receiver: 'users',
  'receiver-team': 'user-teams',
  creator: 'users',
  'presumed-categories': 'categories',
  'presumed-solution-categories': 'solution-categories',
}
