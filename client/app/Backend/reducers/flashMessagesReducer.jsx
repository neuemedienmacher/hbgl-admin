import { assign, omit } from 'lodash'

export default function flashMessagesReducer(state = {}, action) {
  let id, newState

  switch (action.type) {
    case 'ADD_FLASH_MESSAGE':
      id = Date.now().toString()
      newState = assign({}, state)
      newState[id] = {
        id,
        type: action.flashType,
        text: action.text,
      }
      return newState
    case 'REMOVE_FLASH_MESSAGE':
      return omit(state, [action.id])
    default:
      return state
  }
}
