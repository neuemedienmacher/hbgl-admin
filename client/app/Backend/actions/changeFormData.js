export function changeFormData(formId, name, value) {
  return { type: 'CHANGE_FORM_DATA', formId, name, value }
}

export function addSubmodelForm(formId, attribute) {
  return { type: 'ADD_SUBMODEL_FORM', formId, attribute }
}

export function removeSubmodelForm(formId, attribute) {
  return { type: 'REMOVE_SUBMODEL_FORM', formId, attribute }
}
