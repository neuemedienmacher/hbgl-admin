import { FormObject, JsonApiAdapter } from 'rform'

export default class DivisionFormObject extends FormObject {
  static get model() {
    return 'division'
  }

  static get properties() {
    return [
      'name', 'description', 'organization_id', 'section_filter_id'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      description: { type: 'textarea' },
      organization_id: { type: 'filtering-select' },
      section_filter_id: { type: 'filtering-select' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
    this.required('organization_id').filled()
    this.required('section_filter_id').filled()
  }
}
