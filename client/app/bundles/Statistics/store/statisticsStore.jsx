import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import thunkMiddleware from 'redux-thunk'
import loggerMiddleware from 'lib/middlewares/loggerMiddleware'

import rootReducer, { initialStates } from '../reducers'
import fetchStatistics from '../actions/fetchStatistics'
import fetchUsers from '../actions/fetchUsers'

function initialDispatches(dispatch, props) {
  dispatch(fetchStatistics(props.ajaxAuth))
  dispatch(fetchUsers(props.ajaxAuth))
}

export default function getStore(props) {
  // This is how we get initial props Rails into redux.
  const { } = props;

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
