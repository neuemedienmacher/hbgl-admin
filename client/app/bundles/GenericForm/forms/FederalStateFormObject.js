import { FormObject, JsonApiAdapter } from 'rform'

export default class FederalStateFormObject extends FormObject {
  static get model() {
    return 'federal_state'
  }

  static get properties() {
    return [
      'name'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' }
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
  }
}
