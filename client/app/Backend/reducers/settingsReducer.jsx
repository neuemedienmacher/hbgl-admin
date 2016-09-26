import merge from 'lodash/merge'

export const initialState = {
}

export default function settingsReducer(state = initialState, action) {
  switch (action.type) {
    case 'ADD_SETTINGS':
      return merge({}, state, action.settings)
    break

    default:
      return state;
  }
}
