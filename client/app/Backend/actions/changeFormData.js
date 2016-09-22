export function changeFormData(formId, name, value) {
  return { type: 'CHANGE_FORM_DATA', formId, name, value }
}
