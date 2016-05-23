import { compose, createStore, applyMiddleware, combineReducers } from 'redux'
import thunkMiddleware from 'redux-thunk'
import loggerMiddleware from 'lib/middlewares/loggerMiddleware'

import rootReducer, { initialStates } from '../reducers'

export default function getStore(props) {
  // This is how we get initial props Rails into redux.
  const { } = props;

	return createStore(
		rootReducer,
		initialStates,
		applyMiddleware(
			thunkMiddleware,
			loggerMiddleware
		)
	)
}
