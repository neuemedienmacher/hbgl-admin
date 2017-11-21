import kebabCase from 'lodash/kebabCase'
import snakeCase from 'lodash/snakeCase'
import settings from './settings'
import { pluralize, singularize } from './inflection'

export function actionsFromSettings(model, id, entity) {
  const modelSettings = settings.index[model]
  if (!modelSettings) return []

  return modelSettings.member_actions.filter(
    action => visibleFor(action, model, id, entity)
  ).map(action => ({
    name: action,
    icon: iconFor(action),
    href: routeForAction(action, model, id, entity),
    target: targetFor(action),
    text: textFor(action),
  }))
}

function routeForAction(action, model, id, entity) {
  switch(action) {
    case 'old-backend-edit':
      return `/admin/${snakeCase(singularize(model))}/${id}/edit`
    case 'edit':
      return `/${model}/${id}/edit`
    case 'preview':
      return entity && entity.links && entity.links.preview || ''
    case 'show':
      return `/${model}/${id}`
    case 'delete':
      return `/${model}/${id}/delete`
    case 'duplicate':
      return `/${model}/${id}/duplicate`
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
      return !!id
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
      return 'fa fa-info-circle'
    case 'preview':
      return 'fa fa-eye'
    case 'delete':
      return 'fa fa-trash'
    case 'edit-assignable':
      return 'fa fa-pencil-square-o'
    case 'open_url':
      return 'fa fa-external-link'
    case 'duplicate':
      return 'fa fa-files-o'
  }
}

function targetFor(action) {
  switch(action) {
    case 'old-backend-edit':
    case 'preview':
    case 'open_url':
      return '_blank'
    default:
      return ''
  }
}

function textFor(action) {
  switch(action) {
    case 'edit':
      return 'Bearbeiten'
    case 'show':
      return 'Anzeigen'
    case 'preview':
      return 'Anzeigen in App'
    case 'delete':
      return 'Löschen'
    case 'duplicate':
      return 'Duplizieren'
    case 'old-backend-edit':
      return 'Im alten Backend editieren'
    default:
      return action
  }
}
