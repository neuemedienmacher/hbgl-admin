import GenericFormObject from '../lib/GenericFormObject'

export default class NextStepFormObject extends GenericFormObject {
  static get model() {
    return 'next-step'
  }

  static get type() {
    return 'next-steps'
  }

  static get properties() {
    return [
      'text-de', 'text-en', 'text-ar', 'text-fa', 'text-fr', 'text-tr',
      'text-pl', 'text-ru'
    ]
  }

  static get formConfig() {
    return {
       'text-de': { type: 'string' },
       'text-en': { type: 'string' },
       'text-ar': { type: 'string' },
       'text-fa': { type: 'string' },
       'text-fr': { type: 'string' },
       'text-tr': { type: 'string' },
       'text-pl': { type: 'string' },
       'text-ru': { type: 'string' }
    }
  }

  static get requiredInputs() {
    return ['text-de', 'text-en']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
