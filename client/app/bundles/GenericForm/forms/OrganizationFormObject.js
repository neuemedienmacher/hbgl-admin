import GenericFormObject from '../lib/GenericFormObject'
import merge from 'lodash/merge'
import concat from 'lodash/concat'
import WebsiteFormObject from './WebsiteFormObject'
import DivisionFormObject from './DivisionFormObject'
import LocationFormObject from './LocationFormObject'
import ContactPersonFormObject from './ContactPersonFormObject'

class OrgaCreateFormObject extends GenericFormObject {
  static get model() {
    return 'organization'
  }

  static get type() {
    return 'organizations'
  }

  static get properties() {
    return [
      'name', 'website', 'locations', 'contact-people',
      'comment', 'priority', 'pending-reason', 'divisions', 'topics'
    ]
  }

  static get submodels() {
    return ['website', 'divisions', 'locations', 'contact-people', 'topics']
  }

  static get submodelConfig() {
    return {
      website: {
        object: WebsiteFormObject,
        relationship: 'oneToOne'
      },
      divisions: {
        object: DivisionFormObject,
        relationship: 'oneToMany',
        inverseRelationship: 'belongsTo'
      },
      locations: {
        object: LocationFormObject,
        relationship: 'oneToMany',
        inverseRelationship: 'belongsTo'
      },
      'contact-people': {
        object: ContactPersonFormObject,
        relationship: 'oneToMany',
        inverseRelationship: 'belongsTo'
      },
      topics: {
        relationship: 'oneToMany'
      }
    }
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      website: { type: 'creating-select' },
      locations: { type: 'creating-multiselect' },
      'contact-people': { type: 'creating-multiselect' },
      comment: { type: 'textarea' },
      priority: { type: 'checkbox' },
      divisions: { type: 'creating-multiselect' },
      'pending-reason': {
        type: 'select', options: ['', 'unstable', 'on_hold', 'foreign']
      },
      topics: { type: 'filtering-multiselect' },
    }
  }

  static get requiredInputs() {
    return ['name', 'website']
  }

  validation() {
    this.applyRequiredInputs()
  }
}

class OrgaUpdateFormObject extends OrgaCreateFormObject {
  static get properties() {
    return concat(
      OrgaCreateFormObject.properties,
      [ 'description', 'legal-form', 'charitable', 'umbrella-filters',
        'accredited-institution', 'mailings' ]
    )
  }

  static get formConfig() {
    return merge(
      OrgaCreateFormObject.formConfig,
      {
        description: { type: 'textarea' },
        charitable: { type: 'checkbox' },
        'legal-form': {
          type: 'select',
          options: [
            '', 'ev', 'ggmbh', 'gag', 'foundation', 'gug', 'gmbh', 'ag', 'ug',
            'kfm', 'gbr', 'ohg', 'kg', 'eg', 'sonstige', 'state_entity'
          ]
        },
        'umbrella-filters': {
          type: 'filtering-multiselect',
          resource: 'filters',
          filters: { 'type': 'UmbrellaFilter' }
        },
        'accredited-institution': { type: 'checkbox' },
        mailings: { type: 'select',
                    options: ['disabled', 'enabled', 'force_disabled'] },
      },
    )
  }

  static get requiredInputs() {
    return concat(
      OrgaCreateFormObject.requiredInputs, ['description', 'legal-form']
    )
  }

  static get submodels() {
    return concat(OrgaCreateFormObject.submodels, 'umbrella-filters')
  }

  static get submodelConfig() {
    return merge(
      OrgaCreateFormObject.submodelConfig, {
        'umbrella-filters': {
          type: 'filters',
          relationship: 'oneToMany'
        }
      }
    )
  }

  static get readOnlyProperties() {
    return ['aasm-state']
  }

  static additionalButtons(stateInstance) {
    let buttons = []
    if (
      stateInstance && stateInstance['aasm-state'] == 'all_done'
      // stateInstance['current-assignment']['receiver']...
    ) {
      buttons.push({
        className: 'default', buttonLabel: 'Speichern & Zuweisung schließen',
        actionName: 'toSystem'
      })
    }
    return buttons
  }
}

export {
  OrgaCreateFormObject, OrgaUpdateFormObject
}
