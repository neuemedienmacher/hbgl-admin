import GenericFormObject from '../lib/GenericFormObject'

export default class CityFormObject extends GenericFormObject {
  static get model() {
    return 'city'
  }

  static get type() {
    return 'cities'
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
