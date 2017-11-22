import { combineReducers } from 'redux'
import merge from 'lodash/merge'
import ui from './uiReducer'
import settings from './settingsReducer'
import form from './formReducer'
import { reducer as rform, initialState as initialRformState } from 'rform'
import ajax from './loadAjaxDataReducer'
import entities from './entityReducer'
import flashMessages from './flashMessagesReducer'
import cable from './cableReducer'
import filteringSelect
  from '../../bundles/FilteringSelect/reducers/filteringSelectReducer'
import statistics
  from '../../bundles/Statistics/reducers/statisticSettingsReducer'

export default combineReducers({
  rform,
  entities,
  form,
  ui,
  ajax,
  statistics,
  settings,
  filteringSelect,
  flashMessages,
  cable
})
