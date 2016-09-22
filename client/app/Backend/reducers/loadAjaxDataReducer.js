import assign from 'lodash/assign'
import merge from 'lodash/merge'
import isArray from 'lodash/isArray'

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
    if (isArray(action.response.data)) {
      newState = extractArrayIntoObject(action.response.data, newState)
    } else {
      newState = extractDataPointIntoObject(action.response.data, newState)
    }
    if (action.response.included) {
      newState = extractArrayIntoObject(action.response.included, newState)
    }
    return newState

    default:
      return state;
  }
}

function extractArrayIntoObject(array, object) {
  for (let datum of array) {
    object = extractDataPointIntoObject(datum, object)
  }
  return object
}

function extractDataPointIntoObject(datum, object) {
  if (!object[datum.type]) object[datum.type] = {}
  object[datum.type][datum.id] = merge(datum.attributes, {id: datum.id})
  return object
}
