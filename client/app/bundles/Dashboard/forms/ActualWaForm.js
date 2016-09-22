import { FormObject, JsonApiAdapter } from 'rform'

export default class ActualWaFormObject extends FormObject {
  static get properties() {
    return ['actual_wa_hours']
  }

  static get model() {
    return 'time_allocation'
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('actual_wa_hours').filled('int?')
  }
}
