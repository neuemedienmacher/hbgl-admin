import GenericFormObject from '../lib/GenericFormObject'

export default class TagFormObject extends GenericFormObject {
  static get model() {
    return 'target_audience_filters_offer'
  }

  static get type() {
    return 'target_audience_filters_offers'
  }

  static get properties() {
    return [
      'target-audience-filter', 'offer', 'residency-status',
      'gender-first-part-of-stamp', 'gender-second-part-of-stamp',
      'age-from', 'age-to', 'age-visible'
    ]
  }

  static get submodels() {
    return ['target-audience-filter', 'offer']
  }

  static get formConfig() {
    return {
      'target-audience-filter': {
        type: 'filtering-select',
        resource: 'filters',
        params: { filters: { type: 'TargetAudienceFilter' } }
      },
      offer: { type: 'filtering-select' },
      'residency-status': {
        type: 'select', options: [
          '', 'before_the_asylum_decision', 'with_a_residence_permit',
          'with_temporary_suspension_of_deportation',
          'with_deportation_decision'
        ]
      },
      'gender-first-part-of-stamp': {
        type: 'select', options: ['', 'female', 'male']
      },
      'gender-second-part-of-stamp': {
        type: 'select', options: ['', 'female', 'male', 'neutral']
      },
      'age-from': { type: 'number' },
      'age-to': { type: 'number' },
      'age-visible': { type: 'checkbox' }
    }
  }

  static get submodelConfig() {
    return {
      'target-audience-filter': {
        relationship: 'oneToOne'
      },
      offer: {
        relationship: 'oneToOne'
      }
    }
  }

  static get requiredInputs() {
    return ['target-audience-filter', 'age-from', 'age-to']
  }

  validation() {
    this.applyRequiredInputs()
  }

  static get genericFormDefaults() {
    return {
      'age-from': '0',
      'age-to': '99'
    }
  }
}
