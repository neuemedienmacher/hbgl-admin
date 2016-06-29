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
export default function fetchStatistics(authData) {
  return function(dispatch) {
    dispatch(fetchStatisticsRequest())

    return (
      fetch(
        '/api/v1/statistics.json', {
          method: 'GET',
          headers: {
            Authorization: 'Basic ' + btoa(authData)
          }
        }
      ).then(
        function(response) {
          const { status, statusText } = response
          if (status >= 400) {
            dispatch(fetchStatisticsFailure(response))
            throw new Error(`Fetch Statistics Error ${status}: ${statusText}`)
          }
          return response.json()
        }
      ).then(json => {
        console.log('fetchStatistics json', json)
        dispatch(fetchStatisticsSuccess(json))
      })
    )
  }
}

 fetchStatistics
