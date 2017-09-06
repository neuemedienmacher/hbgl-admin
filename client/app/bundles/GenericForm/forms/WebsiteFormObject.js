import GenericFormObject from '../lib/GenericFormObject'
import { URL_REGEX } from '../lib/formats'

export default class WebsiteFormObject extends GenericFormObject {
  static get model() {
    return 'website'
  }

  static get type() {
    return 'websites'
  }

  static get properties() {
    return [
      'host', 'url'
    ]
  }

  static get formConfig() {
    return {
      host: {
        type: 'select',
        options: [
          'own', 'facebook', 'twitter', 'youtube', 'gplus', 'pinterest',
          'document', 'online_consulting', 'chat', 'forum', 'online_course',
          'application_form', 'contact_form', 'other'
        ]
      },
      url: { type: 'string' },
    }
  }

  static get ajaxAdapter() {
    return JsonApiAdapter
  }

  static get requiredInputs() {
    return ['host', 'url']
  }

  static get additionalValidations() {
    return {
      url: { 'format?': URL_REGEX }
    }
  }

  validation() {
    this.applyRequiredInputs()
  }
}
