import { combineReducers } from 'redux'
import merge from 'lodash/merge'
import ui, { initialState as initialUiState } from './uiReducer'
import settings from './settingsReducer'
import form, { initialState as initialFormState } from './formReducer'
import { reducer as rform, initialState as initialRformState }
  from 'rform'
import ajax, { initialState as initialAjaxState }
  from './loadAjaxDataReducer'
import entities, { initialState as initialEntityState }
  from './entityReducer'
import statistics, { initialState as initialStatisticsState }
  from '../../bundles/Statistics/reducers/statisticSettingsReducer'

// export const initialStates = merge(
//   initialEntityState, initialFormState, initialUiState, initialRformState,
//   initialAjaxState, initialStatisticsState
// )

// export default function combinedReducer(state = initialState, action) {
//   const reducers = [
//     entityReducer, formReducer, uiReducer, rformReducer, loadAjaxDataReducer,
//     statisticsReducer
//   ]
//
//   let newState = state
//   for (let reducer of reducers) {
//     newState = reducer(newState, action)
//   }
//   return newState
// }

export default combineReducers({
  rform,
  entities,
  form,
  ui,
  ajax,
  statistics,
  settings,
})
