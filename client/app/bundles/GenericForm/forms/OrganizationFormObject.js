import { FormObject, JsonApiAdapter } from 'rform'
import WebsiteFormObject from './WebsiteFormObject'
import DivisionFormObject from './DivisionFormObject'
import LocationFormObject from './LocationFormObject'
import ContactPersonFormObject from './ContactPersonFormObject'

export default class OrganizationFormObject extends FormObject {
  static get model() {
    return 'organization'
  }

  static get type() {
    return 'organizations'
  }

  static get properties() {
    return [
      'name', 'website', 'locations', 'contact-people',
      'comment', 'priority', 'divisions'
    ]
  }

  static get submodels() {
    return ['website', 'divisions', 'locations', 'contact-people']
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
      },
      locations: {
        object: LocationFormObject,
        relationship: 'oneToMany'
      },
      'contact-people': {
        object: ContactPersonFormObject,
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
