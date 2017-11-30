import merge from 'lodash/merge'
import uuid from 'js-uuid'

export const initialState = {
  index: {
    params: {
      sort_direction: null,
      sort_model: null,
      sort_field: null,
      query: null,
    },
  },
  afterSaveActiveKey: 'to_edit',
  sessionID: uuid(), // Generate a unique session ID
}

export default function uiReducer(state = initialState, action) {
  switch (action.type) {
    case 'SET_UI':
      let uiState = merge({}, state)
      uiState[action.key] = action.value
      return uiState

    default:
      return state
  }
}
