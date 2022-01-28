import { FormObject, JsonApiAdapter } from 'rform'

export default class AssignmentFormObject extends FormObject {
  static get model() {
    return 'assignment'
  }

  static get type() {
    return 'assignments'
  }

  static get properties() {
    return [
      'assignable-id',
      'assignable-type',
      'creator-id',
      'creator-team-id',
      'receiver-id',
      'receiver-team-id',
      'message',
      'topic',
      'created-by-system',
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('assignable-id').filled('int?')
    this.required('assignable-type').filled()
    this.required('message').filled()
    // TODO: moar?
  }
}
