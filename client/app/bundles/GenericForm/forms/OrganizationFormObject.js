import { FormObject, JsonApiAdapter } from 'rform'
import merge from 'lodash/merge'
import WebsiteFormObject from './WebsiteFormObject'
import DivisionFormObject from './DivisionFormObject'
import LocationFormObject from './LocationFormObject'
import ContactPersonFormObject from './ContactPersonFormObject'

class OrgaCreateFormObject extends FormObject {
  static get model() {
    return 'organization'
  }

  static get type() {
    return 'organizations'
  }

  static get properties() {
    return [
      'name', 'website', 'locations', 'contact-people',
      'comment', 'priority', 'pending-reason', 'divisions'
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
      'pending-reason': {
        type: 'select', options: ['', 'unstable', 'on_hold', 'foreign']
      },
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

class OrgaUpdateFormObject extends OrgaCreateFormObject {
  static get properties() {
    return merge(
      OrgaCreateFormObject.properties,
      ['description', 'legal-form', 'charitable', 'umbrella-filters']
    )
  }

  static get formConfig() {
    return merge(
      OrgaCreateFormObject.formConfig,
      {
        description: { type: 'textarea' },
        'legal-form': { type: 'string' },
        charitable: { type: 'checkbox' },
        'umbrella-filters': {
          type: 'filtering-select',
          resource: 'filters',
          filters: { 'type': 'UmbrellaFilter' }
        }
      }
    )
  }
}

export {
  OrgaCreateFormObject, OrgaUpdateFormObject
}
