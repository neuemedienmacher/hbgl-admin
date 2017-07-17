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
    this.required('name').filled({'max_size?': 255})
    this.required('description').filled()
  }
}
