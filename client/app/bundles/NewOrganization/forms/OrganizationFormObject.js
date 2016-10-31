import { FormObject, JsonApiAdapter } from 'rform'

export default class AssignmentFormObject extends FormObject {
  static get model() {
    return 'organization'
  }

  static get properties() {
    return [
      'name'
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
    // TODO: moar?
  }
}
