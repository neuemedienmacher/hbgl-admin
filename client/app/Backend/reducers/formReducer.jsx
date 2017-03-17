import merge from 'lodash/merge'
import moment from 'moment'

export const initialState = {
}

export default function formReducer(state = initialState, action) {
  let form = merge({}, state)
  const submodelKey = 'additionalSubmodelForms'

  switch (action.type) {
    case 'CHANGE_FORM_DATA':
      form[action.formId] = form[action.formId] || {}
      form[action.formId][action.name] = action.value
      return form
    break

    case 'ADD_SUBMODEL_FORM':
      form[action.formId] = form[action.formId] || {}
      form[action.formId][submodelKey] = form[action.formId][submodelKey] || []
      form[action.formId][submodelKey].push(action.attribute)
      return form
    break

    case 'REMOVE_SUBMODEL_FORM':
      form[action.formId] = form[action.formId] || {}
      form[action.formId][submodelKey] = form[action.formId][submodelKey] || []
      let index = form[action.formId][submodelKey].indexOf(action.attribute)
      form[action.formId][submodelKey].splice(index, 1)
      return form
    break

    default:
      return state;
  }
}
