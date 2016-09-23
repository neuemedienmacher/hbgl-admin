import assign from 'lodash/assign'
import merge from 'lodash/merge'

export const initialState = {
  ajax: {
    isLoading: {},
    indexResults: {
      data: [],
      links: {},
      meta: {}
    }
  }
}

export default function loadAjaxDataReducer(state = initialState, action) {
  const { type, response } = action
  let newState = assign({}, state)

  switch (type) {
  case 'LOAD_AJAX_DATA_REQUEST':
    newState.ajax.isLoading[action.key] = true
    return newState

  case 'LOAD_AJAX_DATA_FAILURE':
    newState.ajax.isLoading[action.key] = false
    return newState

  case 'LOAD_AJAX_DATA_SUCCESS':
    newState.ajax.isLoading[action.key] = false
    newState.ajax[action.key] = action.response
    return merge(newState, action.callback(newState, action.response))

    default:
      return state;
  }
}
