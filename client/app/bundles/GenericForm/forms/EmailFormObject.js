import { JsonApiAdapter } from 'rform'
import GenericFormObject from '../lib/GenericFormObject'
import { EMAIL_REGEX } from '../lib/formats'

export default class EmailFormObject extends GenericFormObject {
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

  static get requiredInputs() {
    return ['address']
  }

  static get additionalValidations() {
    return {
      address: { 'format?': EMAIL_REGEX }
    }
  }

  validation() {
    this.applyRequiredInputs()
  }
}
