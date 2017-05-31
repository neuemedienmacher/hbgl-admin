import { FormObject, JsonApiAdapter } from 'rform'

export default class CityFormObject extends FormObject {
  static get model() {
    return 'email'
  }

  static get properties() {
    return [
      'address'
    ]
  }

  static get formConfig() {
    return {
      address: { type: 'string' }
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('address').filled()
  }
}
