import { FormObject, JsonApiAdapter } from 'rform'

export default class OrganizationFormObject extends FormObject {
  static get model() {
    return 'organization'
  }

  static get properties() {
    return [ 'name', 'website_ids', 'priority', 'division_ids' ]
  }

  // static get submodelConfig() {
  //   return {
  //     websites: { properties: ['url'], type: 'has_many' },
  //     divisions: {
  //       properties: [ 'name', 'description', 'section_ids'],
  //       type: 'oneToMany'
  //     }
  //   }
  // }

  static get formConfig() {
    return {
      name: { type: 'string' },
      priority: { type: 'checkbox' },
      website_ids: { type: 'creating-multiselect' },
      division_ids: { type: 'creating-multiselect' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
  }
}
