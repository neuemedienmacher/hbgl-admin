import merge from 'lodash/merge'
import moment from 'moment'

export const initialState = {
}

export default function formReducer(state = initialState, action) {
  let form = merge({}, state)
  const formListKey = 'additionalSubmodelForms'

  switch (action.type) {
    case 'CHANGE_FORM_DATA':
      form[action.formId] = form[action.formId] || {}
      form[action.formId][action.name] = action.value
      return form
    break
    //
    // case 'ADD_SUBMODEL_FORM':
    //   form[action.formId] = form[action.formId] || {}
    //   let selectedPath = form[action.formId]
    //   for (let step of action.submodelPath) {
    //     selectedPath[step] = selectedPath[step] || {}
    //     selectedPath = selectedPath[step]
    //   }
    //   selectedPath[formListKey] = selectedPath[formListKey] || []
    //   selectedPath[formListKey].push(action.attribute)
    //   return form
    // break
    //
    // case 'REMOVE_SUBMODEL_FORM':
    //   form[action.formId] = form[action.formId] || {}
    //   form[action.formId][formListKey] = form[action.formId][formListKey] || []
    //   let index = form[action.formId][formListKey].indexOf(action.attribute)
    //   form[action.formId][formListKey].splice(index, 1)
    //   return form
    // break

    default:
      return state
  }
}
