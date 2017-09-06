import GenericFormObject from '../lib/GenericFormObject'
import concat from 'lodash/concat'
import merge from 'lodash/merge'
import ContactPersonFormObject from './ContactPersonFormObject'
import WebsiteFormObject from './WebsiteFormObject'
import LocationFormObject from './LocationFormObject'

class OfferCreateFormObject extends GenericFormObject {
  static get model() {
    return 'offer'
  }

  static get type() {
    return 'offers'
  }

  static get properties() {
    return [
      'section', 'split-base', 'all-inclusive', 'name', 'description',
      'comment', 'next-steps', 'code-word', 'contact-people',
      'hide-contact-people', 'encounter', 'location', 'area', 'categories',
      'tags', 'solution-category', 'trait-filters', 'language-filters',
      'openings', 'opening-specification', 'websites', 'starts-at',
      'expires-at', 'logic-version'
    ]
  }

  static get submodels() {
    return [
      'section', 'split-base', 'next-steps', 'contact-people', 'location',
      'area', 'categories', 'tags', 'solution-category', 'trait-filters',
      'language-filters', 'openings', 'websites', 'logic-version'
    ]
  }

  static get submodelConfig() {
    return {
      section: {
        relationship: 'oneToOne'
      },
      'split-base': {
        relationship: 'oneToOne',
      },
      'next-steps': {
        relationship: 'oneToMany',
      },
      'contact-people': {
        object: ContactPersonFormObject,
        relationship: 'oneToMany',
      },
      location: {
        object: LocationFormObject,
        relationship: 'oneToOne',
      },
      area: {
        relationship: 'oneToOne',
      },
      cateories: {
        relationship: 'oneToMany',
      },
      tags: {
        relationship: 'oneToMany',
      },
      'solution-category': {
        relationship: 'oneToOne',
      },
      'trait-filters': {
        relationship: 'oneToMany',
      },
      'language-filters': {
        relationship: 'oneToMany',
      },
      openings: {
        relationship: 'oneToMany',
      },
      websites: {
        object: WebsiteFormObject,
        relationship: 'oneToMany',
      },
      'logic-version': {
        relationship: 'oneToOne',
      },
    }
  }

  static get formConfig() {
    return {
      section: { type: 'filtering-select' },
      'split-base': { type: 'filtering-select' },
      'all-inclusive': { type: 'checkbox' },
      name: { type: 'string' },
      description: { type: 'textarea' },
      comment: { type: 'textarea' },
      'next-steps': { type: 'filtering-multiselect' },
      'code-word': { type: 'string' },
      'contact-people': { type: 'creating-multiselect' },
      'hide-contact-people': { type: 'checkbox' },
      encounter: {
        type: 'select', options: [
          'personal', 'hotline', 'email', 'chat', 'online-course', 'forum',
          'portal'
        ]
      },
      location: { type: 'creating-select' },
      area: { type: 'filtering-select' },
      categories: { type: 'filtering-multiselect' },
      tags: { type: 'filtering-multiselect' },
      'solution-category': { type: 'filtering-select' },
      'trait-filters': {
        type: 'filtering-multiselect',
        resource: 'filters', filters: { type: 'TraitFilter' }
      },
      'language-filters': {
        type: 'filtering-multiselect',
        resource: 'filters', filters: { type: 'LanguageFilter' }
      },
      openings: { type: 'filtering-multiselect' },
      'opening-specification': { type: 'textarea' },
      'starts-at': { type: 'date' },
      'expires-at': { type: 'date' },
      websites: { type: 'creating-multiselect' },
      'logic-version': { type: 'filtering-select' },
    }
  }

  static get requiredInputs() {
    return ['name']
  }

  validation() {
    this.applyRequiredInputs()
  }
}

class OfferUpdateFormObject extends OfferCreateFormObject {
  static get properties() {
    return concat(
      OrgaCreateFormObject.properties,
      ['old-next-steps']
    )
  }

  static get formConfig() {
    return merge(
      OrgaCreateFormObject.formConfig, {
        'old-next-steps': { type: 'textarea' },
      }
    )
  }

  static get readOnlyProperties() {
    return ['aasm-state']
  }
}

export {
  OfferCreateFormObject, OfferUpdateFormObject
}
