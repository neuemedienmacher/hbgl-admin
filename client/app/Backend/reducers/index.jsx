import merge from 'lodash/merge'
import uiReducer, { initialState as initialUiState } from './uiReducer'
import formReducer, { initialState as initialFormState } from './formReducer'
import { reducer as rformReducer, initialState as initialRformState }
  from 'rform'
import loadAjaxDataReducer, { initialState as initialAjaxState }
  from './loadAjaxDataReducer'
import entityReducer, { initialState as initialEntityState }
  from './entityReducer'
import statisticsReducer, { initialState as initialStatisticsState }
  from '../../bundles/Statistics/reducers/statisticSettingsReducer'

export const initialStates = merge(
  initialEntityState, initialFormState, initialUiState, initialRformState,
  initialAjaxState, initialStatisticsState
)

export default function combinedReducer(state = initialState, action) {
  const reducers = [
    entityReducer, formReducer, uiReducer, rformReducer, loadAjaxDataReducer,
    statisticsReducer
  ]

  let newState = state
  for (let reducer of reducers) {
    newState = reducer(newState, action)
  }
  return newState
}
