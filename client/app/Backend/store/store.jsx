import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import merge from 'lodash/merge'
import thunkMiddleware from 'redux-thunk'

// TODO: import currently not working - fix when needed
// import loggerMiddleware from 'lib/middlewares/loggerMiddleware'
import normalize from './normalize'
import combinedReducers, { initialStates } from '../reducers'
import addEntities from '../actions/addEntities'
import addSettings from '../actions/addSettings'

function initialDispatches(dispatch, props) {
  dispatch(addEntities(merge(
    normalize('user_teams', props.user_teams).entities,
    normalize('users', props.users).entities,
    normalize('filters', props.filters).entities,
    normalize('productivity_goals', props.productivity_goals).entities,
    normalize('statistics', props.statistics).entities,
    normalize('time_allocations', props.time_allocations).entities,
    { current_user: props.current_user }
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
      thunkMiddleware,
      // loggerMiddleware // for debugging
    )
  )

  initialDispatches(store.dispatch, props)

  return store
}
