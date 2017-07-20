import kebabCase from 'lodash/kebabCase'
import settings from './settings'
import { pluralize } from './inflection'

export function actionsFromSettings(model, id, entity) {
  const modelSettings = settings.index[model]
  if (!modelSettings) return []

  return modelSettings.member_actions.filter(
    action => visibleFor(action, model, id, entity)
  ).map(action => ({
    icon: iconFor(action),
    href: routeForAction(action, model, id, entity)
  }))
}

function routeForAction(action, model, id, entity) {
  switch(action) {
    case 'edit':
      return `/${model}/${id}/edit`
    case 'show':
      return `/${model}/${id}`
    case 'edit_assignable':
      const assignableModel = pluralize(kebabCase(entity['assignable-type']))
      if (assignableModel) {
        return `/${assignableModel}/${entity['assignable-id']}/edit`
      }
    case 'open_url':
      return entity.url // is the url from the label in this case
  }
}

function visibleFor(action, model, id, entity) {
  switch(action) {
    case 'edit_assignable':
    case 'open_url':
      return !!entity
    default:
      return true
  }
}

function iconFor(action) {
  switch(action) {
    case 'edit':
      return 'fa fa-pencil-square'
    case 'show':
      return 'fa fa-eye'
    case 'edit_assignable':
      return 'fa fa-pencil-square-o'
    case 'open_url':
      return 'fa fa-external-link'
  }
}
