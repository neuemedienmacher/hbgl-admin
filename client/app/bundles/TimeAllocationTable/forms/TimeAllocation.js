import { FormObject, JsonApiAdapter } from 'rform'

export default class TimeAllocationFormObject extends FormObject {
  static get properties() {
    return [
      'actual_wa_hours', 'desired_wa_hours', 'year', 'week_number', 'user_id'
    ]
  }

  static get model() {
    return 'time_allocation'
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }
}
