import GenericFormObject from '../lib/GenericFormObject'

export default class OpeningFormObject extends GenericFormObject {
  static get model() {
    return 'opening'
  }

  static get type() {
    return 'openings'
  }

  static get properties() {
    return [
      'day', 'open', 'close'
    ]
  }

  static get formConfig() {
    return {
      day: { type: 'select',
      options: ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']
      },
      open: { type: 'time' },
      close: { type: 'time' }
    }
  }

  static get requiredInputs() {
    return ['day']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
