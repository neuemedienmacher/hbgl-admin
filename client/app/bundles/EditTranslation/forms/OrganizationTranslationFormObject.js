import { FormObject, JsonApiAdapter } from 'rform'

export default class OrganizationTranslationFormObject extends FormObject {
  static get model() {
    return 'organization_translation'
  }

  static get properties() {
    return [
      'description'
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('description').filled()
  }
}
