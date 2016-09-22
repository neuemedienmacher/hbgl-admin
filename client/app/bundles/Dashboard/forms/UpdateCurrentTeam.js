import { FormObject, JsonApiAdapter } from 'rform'

export default class UpdateCurrentTeam extends FormObject {
  static get properties() {
    return ['current_team_id']
  }

  static get model() {
    return 'user'
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }
}
