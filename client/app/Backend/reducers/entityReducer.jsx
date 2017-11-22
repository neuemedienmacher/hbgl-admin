import merge from 'lodash/merge'
import forEach from 'lodash/forEach'

export const initialState = {
  teams: {},
}

export default function entityReducer(state = initialState, action) {
  switch (action.type) {
    case 'ADD_ENTITIES':
      return merge({}, state, action.entities)

    case 'CHANGE_ENTITY':
      let newState = merge({}, state)
      if (
        state[action.model] && state[action.model][action.id]
      ) {
        forEach(action.changes, (changedValue, changedKey) =>
          newState[action.model][action.id][changedKey] = changedValue
        )
      }
      return newState

    default:
      return state;
  }
}
