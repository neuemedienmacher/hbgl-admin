import { encode } from 'querystring'
import { browserHistory } from 'react-router'

export default function queryUpdateMiddleware({getState}) {
  return next => action => {
    if (action.type == 'SET_QUERY') {
      console.log('queryUpdateMiddleware!!')
      console.log(action)
      // browserHistory.replace(`/?${encode(action.value)}`)
      browserHistory.replace(`/?${jQuery.param(action.value)}`)
    }
    return next(action);
  };
}

module.exports = queryUpdateMiddleware;
