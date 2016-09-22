import merge from 'lodash/merge'
import moment from 'moment'

export const initialState = {
  forms: {},
}

export default function formReducer(state = initialState, action) {
  switch (action.type) {
    case 'CHANGE_FORM_DATA':
      let forms = {}
      forms[action.formId] = {}
      forms[action.formId][action.name] = action.value
      return merge({}, state, {forms})
    break

    default:
      return state;
  }
}
