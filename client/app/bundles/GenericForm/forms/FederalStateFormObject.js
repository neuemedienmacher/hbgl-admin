import GenericFormObject from '../lib/GenericFormObject'

export default class FederalStateFormObject extends GenericFormObject {
  static get model() {
    return 'federal-state'
  }

  static get type() {
    return 'federal-states'
  }

  static get properties() {
    return [
      'name'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' }
    }
  }

  static get requiredInputs() {
    return ['name']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
