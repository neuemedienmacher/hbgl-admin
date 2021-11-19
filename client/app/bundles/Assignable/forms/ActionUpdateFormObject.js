import { FormObject, JsonApiAdapter } from 'rform'

export default class ActionUpdateFormObject extends FormObject {
  static get model() {
    return 'assignment'
  }

  static get properties() {
    return ['receiver-id']
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {}
}
