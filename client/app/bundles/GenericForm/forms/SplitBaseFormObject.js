import GenericFormObject from '../lib/GenericFormObject'

export default class SplitBaseFormObject extends GenericFormObject {
  static get model() {
    return 'split-base'
  }

  static get type() {
    return 'split-bases'
  }

  static get properties() {
    return [
      'title', 'clarat-addition', 'code-word', 'comments', 'divisions',
      'solution-category',
    ]
  }

  static get submodels() {
    return [
      'divisions', 'solution-category'
    ]
  }

  static get submodelConfig() {
    return {
      divisions: { relationship: 'oneToMany' },
      'solution-category': { relationship: 'oneToOne' }
    }
  }

  static get formConfig() {
    return {
      title: { type: 'string' },
      'clarat-addition': { type: 'string' },
      'code-word': { type: 'string' },
      divisions: { type: 'filtering-multiselect' },
      'solution-category': { type: 'filtering-select' },
      comments: { type: 'textarea' }
    }
  }

  static get requiredInputs() {
    return ['title', 'solution-category']
  }

  validation() {
    this.applyRequiredInputs()
  }
}
