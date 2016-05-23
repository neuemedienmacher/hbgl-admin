import assign from 'lodash/object/assign'

export const initialState = {
  statistics: [],
  isFetching: false
}

export default function fetchStatisticsReducer(state = initialState, action) {
  const { type, error, response } = action

  switch (type) {
    case 'FETCH_STATISTICS_REQUEST':
      return assign({}, state, {
        isFetching: true
      })

    case 'FETCH_STATISTICS_FAILURE':
      return assign({}, state, {
        isFetching: false
      })

    case 'FETCH_STATISTICS_SUCCESS':
      return assign({}, state, {
        isFetching: false,
        statistics: response
      })

    default:
      return state;
  }
}
