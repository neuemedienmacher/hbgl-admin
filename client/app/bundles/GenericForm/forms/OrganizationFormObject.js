import { FormObject, JsonApiAdapter } from 'rform'

export default class AssignmentFormObject extends FormObject {
  static get model() {
    return 'organization'
  }

  static get properties() {
    return [ 'name', 'website_ids', 'priority', 'division_ids' ]
  }

  static get submodels() {
    return ['websites', 'divisions']
  }

  static get submodelConfig() {
    return {
      websites: { properties: ['url'], type: 'has_many' },
      divisions: {
        properties: [ 'name', 'description', 'section_filter_ids'],
        type: 'oneToMany'
      }
    }
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      priority: { type: 'checkbox' },
      website_ids: { type: 'creating-multiselect' },
      websites: {
        url: { type: 'string' }
      },
      division_ids: { type: 'creating-multiselect' },
      divisions: {
        name: { type: 'string' },
        description: { type: 'textarea' },
        section_filter_ids: { type: 'filtering-select' },
      },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()

    this.inSubmodel('divisions', () => {
      this.required('name').filled()
    })
  }
}
