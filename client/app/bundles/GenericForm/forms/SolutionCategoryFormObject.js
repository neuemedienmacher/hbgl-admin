import GenericFormObject from '../lib/GenericFormObject'

export default class SolutionCategoryFormObject extends GenericFormObject {
  static get model() {
    return 'solution-category'
  }

  static get type() {
    return 'solution-categories'
  }

  static get properties() {
    return [
      'name', 'parent'
    ]
  }

  static get formConfig() {
    return {
      name: { type: 'string' },
      parent: { type: 'filtering-select', resource: 'solution-categories' }
    }
  }

  static get submodels() {
    return [
      'parent'
    ]
  }

  static get submodelConfig() {
    return {
      parent: { relationship: 'oneToOne' }
    }
  }

  static get requiredInputs() {
    return ['name']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
