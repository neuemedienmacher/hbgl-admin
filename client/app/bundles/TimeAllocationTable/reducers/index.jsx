import merge from 'lodash/merge'
import entityReducer, { initialState as initialEntityState } from './entityReducer'
import formReducer, { initialState as initialFormState } from './formReducer'

export const initialStates = merge(initialEntityState, initialFormState)

export default function combinedReducer(state = initialState, action) {
  const reducers = [entityReducer, formReducer]

  let newState = state
  for (let reducer of reducers) {
    newState = reducer(newState, action)
  }
  return newState
}
