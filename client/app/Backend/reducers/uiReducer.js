import merge from 'lodash/merge'

export const initialState = {
  ui: {
    index: {
      params: {
        direction: null,
        sort: null,
        query: null,
      },
    },
  },
}

export default function uiReducer(state = initialState, action) {
  switch (action.type) {
    case 'SET_UI':
      let uiState = merge({}, state)
      uiState.ui[action.key] = action.value
      return uiState

    default:
      return state;
  }
}
