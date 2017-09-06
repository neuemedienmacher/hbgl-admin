import { FormObject, JsonApiAdapter } from 'rform'

export default class GenericFormObject extends FormObject {
  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  static get requiredInputs() {
    return []
  }

  static get additionalValidations() {
    return {}
  }

  applyRequiredInputs() {
    for (let requiredInput of this.constructor.requiredInputs) {
      const additionalValidations =
        this.constructor.additionalValidations[requiredInput]

      if (additionalValidations) {
        this.required(requiredInput).filled(additionalValidations)
      } else {
        this.required(requiredInput).filled()
      }
    }
  }
}
