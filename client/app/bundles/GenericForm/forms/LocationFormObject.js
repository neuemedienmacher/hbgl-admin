import GenericFormObject from '../lib/GenericFormObject'

export default class LocationFormObject extends GenericFormObject {
  static get model() {
    return 'location'
  }

  static get type() {
    return 'locations'
  }

  static get properties() {
    return [
      'name', 'street', 'addition', 'zip', 'hq', 'visible', 'in-germany',
      'organization', 'city', 'federal-state'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      street: { type: 'string' },
      addition: { type: 'string' },
      zip: { type: 'string' },
      hq: { type: 'checkbox' },
      visible: { type: 'checkbox' },
      'in-germany': { type: 'checkbox' },
      organization: { type: 'filtering-select' },
      city: { type: 'filtering-select' },
      'federal-state': { type: 'filtering-select' },
    }
  }

  static get submodels() {
    return ['city', 'federal-state', 'organization']
  }

  static get submodelConfig() {
    return {
      organization: { relationship: 'oneToOne' },
      city: { relationship: 'oneToOne' },
      'federal-state': { relationship: 'oneToOne' },
    }
  }

  static get requiredInputs() {
    return ['street', 'zip']
  }

  validation() {
    this.applyRequiredInputs()
  }

  static get genericFormDefaults() {
    return {
      'in-germany': true,
      visible: true
    }
  }
}
