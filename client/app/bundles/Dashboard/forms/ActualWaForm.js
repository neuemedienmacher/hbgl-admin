import { FormObject, JsonApiAdapter } from 'rform'

export default class ActualWaFormObject extends FormObject {
  static get properties() {
    return ['actual-wa-hours', 'actual-wa-comment']
  }

  static get model() {
    return 'time_allocation'
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('actual-wa-hours').filled('int?')
  }
}
