import { FormObject, JsonApiAdapter } from 'rform'

export default class AssignmentFormObject extends FormObject {
  static get model() {
    return 'assignment'
  }

  static get properties() {
    return [
      'assignable_id', 'assignable_type', 'creator_id', 'creator_team_id',
      'receiver_id', 'receiver_team_id', 'message'
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('assignable_id').filled('int?')
    this.required('assignable_type').filled()
    this.required('message').filled()
    // TODO: moar?
  }
}
