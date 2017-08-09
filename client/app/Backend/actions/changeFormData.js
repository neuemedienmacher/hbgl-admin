export function changeFormData(formId, name, value) {
  return { type: 'CHANGE_FORM_DATA', formId, name, value }
}

export function addSubmodelForm(formId, attribute, submodelPath = []) {
  return { type: 'ADD_SUBMODEL_FORM', formId, attribute, submodelPath }
}

export function removeSubmodelForm(formId, attribute, submodelPath = []) {
  return { type: 'REMOVE_SUBMODEL_FORM', formId, attribute, submodelPath }
}
