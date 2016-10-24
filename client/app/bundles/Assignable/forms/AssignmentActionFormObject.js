import { FormObject, JsonApiAdapter } from 'rform'

export default class AssignmentActionFormObject extends FormObject {
  static get model() {
    return 'assignment'
  }

  static get properties() {
    return [
      'reciever_id', 'aasm_state'
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() { }
}
