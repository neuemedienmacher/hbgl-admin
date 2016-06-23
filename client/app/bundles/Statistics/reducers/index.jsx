// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/HelloWorld/store/statisticsStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.
// `https://github.com/shakacode/react_on_rails/tree/master/docs/additional_reading/generated_client_code.md`
import merge from 'lodash/object/merge'
import { combineReducers } from 'redux'
import fetchStatisticsReducer from './fetchStatisticsReducer'
import { initialState as fetchStatisticsState } from './fetchStatisticsReducer'
import statisticSettingsReducer from './statisticSettingsReducer'
import { initialState as settingsState } from './statisticSettingsReducer'

export const initialStates = merge(fetchStatisticsState, settingsState)

export default function combinedReducer(state = initialState, action) {
  const reducers = [ fetchStatisticsReducer, statisticSettingsReducer ]

  let newState = state
  for (let reducer of reducers) {
    newState = reducer(newState, action)
  }
  return newState
}
