import { combineReducers } from 'redux'
import merge from 'lodash/merge'
import ui from './uiReducer'
import settings from './settingsReducer'
import form from './formReducer'
import { reducer as rform, initialState as initialRformState } from 'rform'
import ajax from './loadAjaxDataReducer'
import entities from './entityReducer'
import multiSelect from '../../bundles/GenericForm/reducers/multiSelectReducer'
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
  multiSelect,
})
