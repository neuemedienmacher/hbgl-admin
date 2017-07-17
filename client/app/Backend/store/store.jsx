import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import merge from 'lodash/merge'
import thunkMiddleware from 'redux-thunk'
import errorHandlerMiddleware from './errorHandlerMiddleware'
import loggerMiddleware from 'lib/middlewares/loggerMiddleware'
import combinedReducers, { initialStates } from '../reducers'
import addEntities from '../actions/addEntities'
import addSettings from '../actions/addSettings'
import transformJsonApi from '../transformers/json_api'

function initialDispatches(dispatch, props) {
  dispatch(addEntities(merge(
    transformJsonApi(props['user-teams']),
    transformJsonApi(props.users),
    { 'current-user-id': props['current-user-id'] }
  )))
  dispatch(addSettings(merge(
    { authToken: props.authToken },
    props.settings
  )))
}

export default function getStore(props) {
  const store = createStore(
    combinedReducers,
    // initialStates,
    applyMiddleware(
      thunkMiddleware, errorHandlerMiddleware,
      // loggerMiddleware // for debugging
    )
  )

  initialDispatches(store.dispatch, props)

  return store
}
