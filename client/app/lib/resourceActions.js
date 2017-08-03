import kebabCase from 'lodash/kebabCase'
import settings from './settings'
import { pluralize, singularize } from './inflection'

export function actionsFromSettings(model, id, entity) {
  const modelSettings = settings.index[model]
  if (!modelSettings) return []

  return modelSettings.member_actions.filter(
    action => visibleFor(action, model, id, entity)
  ).map(action => ({
    icon: iconFor(action),
    href: routeForAction(action, model, id, entity),
    target: targetFor(action)
  }))
}

function routeForAction(action, model, id, entity) {
  switch(action) {
    case 'old-backend-edit':
      return `/admin/${singularize(model)}/${id}/edit`
    case 'edit':
      return `/${model}/${id}/edit`
    case 'show':
      return `/${model}/${id}`
    case 'show-assignable':
    case 'edit-assignable':
      let assignableModel = pluralize(kebabCase(entity['assignable-type']))
      if (assignableModel) {
        let addition = action == 'edit-assignable' ? '/edit' : ''
        return `/${assignableModel}/${entity['assignable-id']}${addition}`
      }
    case 'open_url':
      return entity.url // is the url from the label in this case
  }
}

function visibleFor(action, model, id, entity) {
  switch(action) {
    case 'edit-assignable':
    case 'show-assignable':
    case 'open_url':
      return !!entity
    default:
      return true
  }
}

function iconFor(action) {
  switch(action) {
    case 'old-backend-edit':
    case 'edit':
      return 'fa fa-pencil-square'
    case 'show-assignable':
      return 'fa fa-arrow-circle-o-right'
    case 'show':
      return 'fa fa-eye'
    case 'edit-assignable':
      return 'fa fa-pencil-square-o'
    case 'open_url':
      return 'fa fa-external-link'
  }
}

function targetFor(action) {
  switch(action) {
    case 'old-backend-edit':
    case 'open_url':
      return '_blank'
    default:
      return ''
  }
}
