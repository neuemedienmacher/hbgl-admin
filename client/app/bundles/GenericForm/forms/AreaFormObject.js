import GenericFormObject from '../lib/GenericFormObject'

export default class AreaFormObject extends GenericFormObject {
  static get model() {
    return 'area'
  }

  static get type() {
    return 'areas'
  }

  static get properties() {
    return [
      'name', 'minlat', 'maxlat', 'minlong', 'maxlong'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      minlat: { type: 'number' },
      maxlat: { type: 'number' },
      minlong: { type: 'number' },
      maxlong: { type: 'number' }
    }
  }

  static get requiredInputs() {
    return ['name']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
