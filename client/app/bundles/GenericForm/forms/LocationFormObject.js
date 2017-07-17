import { FormObject, JsonApiAdapter } from 'rform'

export default class LocationFormObject extends FormObject {
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
    return ['city', 'federal-state']
  }

  static get submodelConfig() {
    return {
      city: { relationship: 'oneToOne' },
      'federal-state': { relationship: 'oneToOne' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('street').filled()
    this.required('zip').filled()
    // this.required('organization').filled()
    // this.required('city').filled()
    // this.required('federal-state').filled()
  }

  static get genericFormDefaults() {
    return {
      'in-germany': true,
      visible: true
    }
  }
}
