import fetch from 'isomorphic-fetch'

const fetchStatisticsRequest = function() {
  return {
    type: 'FETCH_STATISTICS_REQUEST'
  }
}
const fetchStatisticsFailure = function(error) {
  return {
    type: 'FETCH_STATISTICS_FAILURE',
    error
  }
}
const fetchStatisticsSuccess = function(response) {
  return {
    type: 'FETCH_STATISTICS_SUCCESS',
    response
  }
}
export default function fetchStatistics() {
  return function(dispatch) {
    dispatch(fetchStatisticsRequest())

    return fetch('/api/v1/statistics.json')
      .then(
        function(response) {
          if (response.status >= 400) {
            dispatch(fetchStatisticsError(response))
            throw new Error(response)
          }
          return response.json()
        }
      ).then(json => dispatch(fetchStatisticsSuccess(json)))
  }
}

 fetchStatistics
