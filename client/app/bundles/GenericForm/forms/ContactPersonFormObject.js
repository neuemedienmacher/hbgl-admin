import { FormObject, JsonApiAdapter } from 'rform'

export default class CityFormObject extends FormObject {
  static get model() {
    return 'contact_person'
  }

  static get properties() {
    return [
      'address', 'area_code_1', 'area_code_2', 'local_number_1',
      'local_number_2', 'fax_area_code', 'fax_number', 'first_name',
      'last_name', 'operational_name', 'academic_title', 'gender',
      'responsibility', 'position', 'street', 'zip_and_city', 'spoc',
      'organization_id', 'email_id'
    ]
  }

  static get formConfig() {
    return {
      address: { type: 'string' },
      area_code_1: { type: 'string' },
      area_code_2: { type: 'string' },
      local_number_1: { type: 'string' },
      local_number_2: { type: 'string' },
      fax_area_code: { type: 'string' },
      fax_number: { type: 'string' },
      first_name: { type: 'string' },
      last_name: { type: 'string' },
      operational_name: { type: 'string' },
      academic_title: { type: 'select', options: ['dr', 'prof_dr'] },
      gender: { type: 'select', options: ['male', 'female'] },
      responsibility: { type: 'string' },
      position: {
        type: 'select', options: ['superior', 'public_relations', 'other']
      },
      street: { type: 'string' },
      zip_and_city: { type: 'string' },
      spoc: { type: 'checkbox' },
      organization_id: { type: 'creating-select' },
      email_id: { type: 'creating-select' }
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('address').filled()
    this.required('organization_id').filled()
  }
}
