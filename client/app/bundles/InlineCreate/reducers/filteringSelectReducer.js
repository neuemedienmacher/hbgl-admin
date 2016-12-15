import assign from 'lodash/assign'
import uniqBy from 'lodash/uniqBy'

export const initialState = {
  isLoading: {},
  alreadyLoadedInputs: {},
  options: {}
}

export default function filteringSelectReducer(state = initialState, action) {
  const { type, response, key } = action
  let newState = assign({}, state)

  switch (type) {
  case 'LOAD_FOR_FILTERING_SELECT_REQUEST':
    newState.isLoading[key] = true
    if (!newState.options[key]) newState.options[key] = []
    if (!newState.alreadyLoadedInputs[key])
      newState.alreadyLoadedInputs[key] = []
    newState.alreadyLoadedInputs[key].push(action.input)
    return newState

  case 'LOAD_FOR_FILTERING_SELECT_FAILURE':
    newState.isLoading[key] = false
    return newState

  case 'LOAD_FOR_FILTERING_SELECT_SUCCESS':
    newState.isLoading[key] = false
    // merge past and current options
    newState.options[key] =
      uniqBy(newState.options[key].concat(action.options), e => e.value)
    return newState

    default:
      return state;
  }
}
