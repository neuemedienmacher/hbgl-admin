import { FormObject, JsonApiAdapter } from 'rform'

export default class OfferTranslationFormObject extends FormObject {
  static get model() {
    return 'offer_translation'
  }

  static get properties() {
    return [
      'name', 'description', 'opening_specification'
    ]
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('name').filled()
    this.required('description').filled()
  }
}
