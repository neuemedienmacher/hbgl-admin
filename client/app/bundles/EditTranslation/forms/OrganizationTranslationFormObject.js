import { FormObject, JsonApiAdapter } from 'rform'

export default class OrganizationTranslationFormObject extends FormObject {
  static get model() {
    return 'organization-translation'
  }

  static get type() {
    return 'organization-translations'
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
