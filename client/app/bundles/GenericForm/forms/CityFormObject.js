import { FormObject, JsonApiAdapter } from 'rform'

export default class CityFormObject extends FormObject {
  static get model() {
    return 'city'
  }

  static get type() {
    return 'cities'
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
