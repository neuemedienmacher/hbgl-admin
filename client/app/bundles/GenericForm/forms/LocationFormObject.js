import { FormObject, JsonApiAdapter } from 'rform'

export default class LocationFormObject extends FormObject {
  static get model() {
    return 'location'
  }

  static get properties() {
    return [
      'name', 'street', 'addition', 'zip', 'hq', 'visible', 'in_germany',
      'organization_id', 'city_id', 'federal_state_id'
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
      in_germany: { type: 'checkbox' },
      organization_id: { type: 'creating-select' },
      city_id: { type: 'creating-select' },
      federal_state_id: { type: 'filtering-select' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('street').filled()
    this.required('zip').filled()
    // this.required('organization_id').filled()
    // this.required('city_id').filled()
    // this.required('federal_state_id').filled()
  }
}
