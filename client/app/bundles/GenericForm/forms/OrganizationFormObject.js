import { FormObject, JsonApiAdapter } from 'rform'
import WebsiteFormObject from './WebsiteFormObject'
import DivisionFormObject from './DivisionFormObject'

export default class OrganizationFormObject extends FormObject {
  static get model() {
    return 'organization'
  }

  static get type() {
    return 'organizations'
  }

  static get properties() {
    return [
      'name', 'priority', 'website', 'locations', 'contact-people',
      'comment', 'divisions'
    ]
  }

  static get submodels() {
    return ['website', 'divisions'] // , 'locations', 'contact-people'
  }

  static get submodelConfig() {
    return {
      website: {
        object: WebsiteFormObject,
        relationship: 'oneToOne'
      },
      divisions: {
        object: DivisionFormObject,
        relationship: 'oneToMany'
      }
    }
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      website: { type: 'creating-select' },
      locations: { type: 'creating-multiselect' },
      'contact-people': { type: 'creating-multiselect' },
      comment: { type: 'textarea' },
      priority: { type: 'checkbox' },
      divisions: { type: 'creating-multiselect' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
    this.required('website').filled()
  }
}
