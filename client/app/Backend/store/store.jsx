import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import merge from 'lodash/merge'
import thunkMiddleware from 'redux-thunk'

import loggerMiddleware from 'lib/middlewares/loggerMiddleware'
import normalize from './normalize'
import rootReducer, { initialStates } from '../reducers'
import addEntities from '../actions/addEntities'

function initialDispatches(dispatch, props) {
  dispatch(addEntities(merge(
    normalize('user_teams', props.user_teams).entities,
    normalize('users', props.users).entities,
    normalize('productivity_goals', props.productivity_goals).entities,
    normalize('statistics', props.statistics).entities,
    normalize('time_allocations', props.time_allocations).entities,
    {
      current_user: props.current_user,
      settings: props.settings,
      authToken: props.authToken,
    }
  )))
}

export default function getStore(props) {
	const store = createStore(
		rootReducer,
		initialStates,
		applyMiddleware(
			thunkMiddleware,
      // loggerMiddleware // for debugging
		)
	)

  initialDispatches(store.dispatch, props)

  return store
}
