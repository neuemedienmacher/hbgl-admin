import assign from 'lodash/assign'
import merge from 'lodash/merge'

export const initialState = {
  isLoading: {},
  indexResults: {
    data: [],
    links: {},
    meta: {}
  }
}

export default function loadAjaxDataReducer(state = initialState, action) {
  const { type, response } = action
  let newState = assign({}, state)

  switch (type) {
  case 'LOAD_AJAX_DATA_REQUEST':
    newState.isLoading[action.key] = true
    return newState

  case 'LOAD_AJAX_DATA_FAILURE':
    newState.isLoading[action.key] = false
    return newState

  case 'LOAD_AJAX_DATA_SUCCESS':
    newState.isLoading[action.key] = false
    newState[action.key] = action.response
    return newState

    default:
      return state;
  }
}
