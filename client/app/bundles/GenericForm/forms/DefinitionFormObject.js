import GenericFormObject from '../lib/GenericFormObject'

export default class DefinitionFormObject extends GenericFormObject {
  static get model() {
    return 'definition'
  }

  static get type() {
    return 'definitions'
  }

  static get properties() {
    return [
      'key', 'explanation'
    ]
  }

  static get formConfig() {
    return {
      key: { type: 'text' },
      explanation: { type: 'text' }
    }
  }

  static get requiredInputs() {
    return ['key', 'explanation']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
