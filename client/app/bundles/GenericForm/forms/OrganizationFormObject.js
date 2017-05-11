import { FormObject, JsonApiAdapter } from 'rform'

export default class OrganizationFormObject extends FormObject {
  static get model() {
    return 'organization'
  }

  static get properties() {
    return [
      'name', 'priority', 'website_id', 'location_ids', 'contact_person_ids',
      'comment', 'division_ids'
    ]
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
      website_id: { type: 'creating-select' },
      location_ids: { type: 'creating-multiselect' },
      contact_person_ids: { type: 'creating-multiselect' },
      comment: { type: 'textarea' },
      priority: { type: 'checkbox' },
      division_ids: { type: 'creating-multiselect' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
    this.required('website_id').filled()
  }
}
