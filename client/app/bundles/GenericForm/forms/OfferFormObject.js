import GenericFormObject from '../lib/GenericFormObject'
import concat from 'lodash/concat'
import merge from 'lodash/merge'
import ContactPersonFormObject from './ContactPersonFormObject'
import WebsiteFormObject from './WebsiteFormObject'
import LocationFormObject from './LocationFormObject'
import TargetAudienceFiltersOfferFormObject
  from './TargetAudienceFiltersOfferFormObject'

class OfferCreateFormObject extends GenericFormObject {
  static get model() {
    return 'offer'
  }

  static get type() {
    return 'offers'
  }

  static get properties() {
    return [
      'section', 'split-base', 'name', 'description',
      'comment', 'next-steps', 'contact-people',
      'hide-contact-people', 'encounter', 'location', 'area', 'categories',
      'tags', 'trait-filters', 'language-filters',
      'target-audience-filters-offers', 'openings', 'opening-specification',
      'websites', 'starts-at', 'ends-at', 'logic-version'
    ]
  }

  static get submodels() {
    return [
      'section', 'split-base', 'next-steps', 'contact-people', 'location',
      'area', 'categories', 'tags', 'trait-filters',
      'language-filters', 'target-audience-filters-offers', 'openings',
      'websites', 'logic-version'
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
      categories: {
        relationship: 'oneToMany',
      },
      tags: {
        relationship: 'oneToMany',
      },
      'trait-filters': {
        relationship: 'oneToMany',
      },
      'language-filters': {
        relationship: 'oneToMany',
      },
      'target-audience-filters-offers': {
        object: TargetAudienceFiltersOfferFormObject,
        relationship: 'oneToMany',
        inverseRelationship: 'belongsTo'
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
      name: { type: 'string' },
      description: { type: 'textarea' },
      comment: { type: 'textarea' },
      'next-steps': { type: 'filtering-multiselect' },
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
      'trait-filters': {
        type: 'filtering-multiselect',
        resource: 'filters',
        params: { filters: { type: 'TraitFilter' } }
      },
      'language-filters': {
        type: 'filtering-multiselect',
        resource: 'filters',
        params: { filters: { type: 'LanguageFilter' } }
      },
      'target-audience-filters-offers': {
        type: 'creating-multiselect'
      },
      openings: {
        type: 'filtering-multiselect',
        params: { sort_field: 'sort_value', sort_direction: 'ASC' }
      },
      'opening-specification': { type: 'textarea' },
      'starts-at': { type: 'date' },
      'ends-at': { type: 'date' },
      websites: { type: 'creating-multiselect' },
      'logic-version': { type: 'filtering-select' },
    }
  }

  static get requiredInputs() {
    return [
      'section', 'split-base', 'name', 'target-audience-filters-offers',
      'language-filters', 'description'
    ]
  }

  validation() {
    this.applyRequiredInputs()
  }
}

class OfferUpdateFormObject extends OfferCreateFormObject {
  // static get properties() {
  //   return concat(
  //     OfferCreateFormObject.properties,
  //     ['old-next-steps']
  //   )
  // }
  //
  // static get formConfig() {
  //   return merge(
  //     OfferCreateFormObject.formConfig, {
  //       'old-next-steps': { type: 'textarea' },
  //     }
  //   )
  // }

  static get readOnlyProperties() {
    return ['aasm-state']
  }
}

export {
  OfferCreateFormObject, OfferUpdateFormObject
}
