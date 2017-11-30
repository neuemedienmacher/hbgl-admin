import merge from 'lodash/merge'

export const initialState = {
  queryString: '',
  params: {}
}

export default function queryReducer(state = initialState, action) {
  switch (action.type) {
    case 'SET_QUERY':
      let queryState = merge({}, state)
      queryState[action.key] = action.value
      return queryState
    default:
      return state
  }
}
