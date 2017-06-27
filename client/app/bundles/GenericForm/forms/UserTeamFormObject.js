import { FormObject, JsonApiAdapter } from 'rform'

export default class UserTeamFormObject extends FormObject {
  static get model() {
    return 'user_team'
  }

  static get type() {
    return 'user_teams'
  }

  static get properties() {
    return [
      'name', 'users', 'observing_users'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      users: { type: 'filtering-multiselect' },
      observing_users: { type: 'filtering-multiselect' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
  }
}
