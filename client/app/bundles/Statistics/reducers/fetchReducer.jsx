import assign from 'lodash/object/assign'

export const initialState = {
  statistics: [],
  users: [],
  isFetching: {
    statistics: false,
    users: false,
  }
}

export default function fetchReducer(state = initialState, action) {
  const { type, error, response } = action

  switch (type) {
    case 'FETCH_STATISTICS_REQUEST':
      return assign({}, state, {
        isFetching: { statistics: true }
      })

    case 'FETCH_STATISTICS_FAILURE':
      return assign({}, state, {
        isFetching: { statistics: false }
      })

    case 'FETCH_STATISTICS_SUCCESS':
      return assign({}, state, {
        isFetching: { statistics: false },
        statistics: response
      })

    case 'FETCH_USERS_REQUEST':
      return assign({}, state, {
        isFetching: { users: true }
      })

    case 'FETCH_USERS_FAILURE':
      return assign({}, state, {
        isFetching: { users: false }
      })

    case 'FETCH_USERS_SUCCESS':
      return assign({}, state, {
        isFetching: { users: false },
        users: response
      })

    default:
      return state;
  }
}
