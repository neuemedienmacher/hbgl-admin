import { FormObject, JsonApiAdapter } from 'rform'
import { EMAIL_REGEX } from '../lib/formats'

export default class EmailFormObject extends FormObject {
  static get model() {
    return 'email'
  }

  static get type() {
    return 'emails'
  }

  static get properties() {
    return ['address']
  }

  static get formConfig() {
    return {
      address: { type: 'string' }
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  validation() {
    this.required('address').filled({ 'format?': EMAIL_REGEX })
  }
}
