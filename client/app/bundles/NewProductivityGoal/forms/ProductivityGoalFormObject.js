import { FormObject, JsonApiAdapter } from 'rform'

export default class ProductivityGoalFormObject extends FormObject {
  static get model() {
    return 'productivity_goal'
  }

  static get properties() {
    return [
      'user_team_id', 'target_model', 'target_field_name', 'target_field_value',
      'target_count', 'starts_at', 'ends_at', 'title'
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('user_team_id').filled()
    this.required('title').filled()
    this.required('target_count').filled('int?')
  }
}
