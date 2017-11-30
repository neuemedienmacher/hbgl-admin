import GenericFormObject from '../lib/GenericFormObject'

export default class LogicVersionFormObject extends GenericFormObject {
  static get model() {
    return 'logic-version'
  }

  static get type() {
    return 'logic-versions'
  }

  static get properties() {
    return [
      'name', 'version'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      version: { type: 'number' }
    }
  }

  static get requiredInputs() {
    return ['name', 'version']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
