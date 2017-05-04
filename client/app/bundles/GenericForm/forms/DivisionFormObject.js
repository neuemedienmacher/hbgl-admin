import { FormObject, JsonApiAdapter } from 'rform'

export default class DivisionFormObject extends FormObject {
  static get model() {
    return 'division'
  }

  static get properties() {
    return [
      'name', 'organization_id', 'section_id', 'website_ids',
      'presumed_category_ids', 'presumed_solution_category_ids', 'comment',
      'size'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      organization_id: { type: 'filtering-select' },
      section_id: { type: 'filtering-select' },
      website_ids: { type: 'creating-multiselect' },
      presumed_category_ids: {
        type: 'filtering-multiselect', resource: 'categories'
      },
      presumed_solution_category_ids: {
        type: 'filtering-multiselect', resource: 'solution_categories'
      },
      comment: { type: 'textarea' },
      size: { type: 'select', options: ['small', 'medium', 'large'] },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
    this.required('section_id').filled()
  }
}
