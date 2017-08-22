import GenericFormObject from '../lib/GenericFormObject'

export default class UserTeamFormObject extends GenericFormObject {
  static get model() {
    return 'user-team'
  }

  static get type() {
    return 'user-teams'
  }

  static get properties() {
    return [
      'name', 'users', 'observing-users'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      users: { type: 'filtering-multiselect' },
      'observing-users': { type: 'filtering-multiselect', resource: 'users' },
    }
  }

  static get requiredInputs() {
    return ['name']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
