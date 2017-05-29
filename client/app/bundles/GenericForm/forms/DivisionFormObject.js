import { FormObject, JsonApiAdapter } from 'rform'
import WebsiteFormObject from './WebsiteFormObject'

export default class DivisionFormObject extends FormObject {
  static get model() {
    return 'division'
  }

  static get properties() {
    return [
      'name', 'organization', 'section', 'websites',
      'presumed-categories', 'presumed-solution-categories', 'comment',
      'size'
    ]
  }

  static get submodels() {
    return ['websites']
  }

  static get submodelConfig() {
    return {
      websites: { type: 'oneToMany', object: WebsiteFormObject }
    }
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      organization: { type: 'filtering-select' },
      section: { type: 'filtering-select' },
      websites: { type: 'creating-multiselect' },
      'presumed-categories': {
        type: 'filtering-multiselect', resource: 'categories'
      },
      'presumed-solution-categories': {
        type: 'filtering-multiselect', resource: 'solution-categories'
      },
      comment: { type: 'textarea' },
      size: { type: 'select', options: ['small', 'medium', 'large'] },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
    this.required('section').filled()
  }
}
