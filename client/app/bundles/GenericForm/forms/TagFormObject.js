import GenericFormObject from '../lib/GenericFormObject'

export default class TagFormObject extends GenericFormObject {
  static get model() {
    return 'tag'
  }

  static get type() {
    return 'tags'
  }

  static get properties() {
    return [
      'name-de', 'keywords-de', 'explanations-de', 'name-en', 'keywords-en',
      'explanations-en', 'name-ar', 'keywords-ar', 'explanations-ar',
      'name-fa', 'keywords-fa', 'explanations-fa', 'name-fr', 'name-tr',
      'name-pl', 'name-ru'
    ]
  }

  static get formConfig() {
    return {
       'name-de': { type: 'string' },
       'keywords-de': { type: 'textarea' },
       'explanations-de': { type: 'textarea' },
       'name-en': { type: 'string' },
       'keywords-en': { type: 'textarea' },
       'explanations-en': { type: 'textarea' },
       'name-ar': { type: 'string' },
       'keywords-ar': { type: 'textarea' },
       'explanations-ar': { type: 'textarea' },
       'name-fa': { type: 'string' },
       'keywords-fa': { type: 'textarea' },
       'explanations-fa': { type: 'textarea' },
       'name-fr': { type: 'string' },
       'name-tr': { type: 'string' },
       'name-pl': { type: 'string' },
       'name-ru': { type: 'string' }
    }
  }

  static get requiredInputs() {
    return ['name-de', 'name-en']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
