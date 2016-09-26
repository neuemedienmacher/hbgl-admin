import merge from 'lodash/merge'

export const initialState = {
  index: {
    params: {
      direction: null,
      sort: null,
      query: null,
    },
  },
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
