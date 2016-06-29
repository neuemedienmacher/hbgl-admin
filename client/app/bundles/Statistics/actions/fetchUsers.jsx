import fetch from 'isomorphic-fetch'

const fetchUsersRequest = function() {
  return {
    type: 'FETCH_USERS_REQUEST'
  }
}
const fetchUsersFailure = function(error) {
  return {
    type: 'FETCH_USERS_FAILURE',
    error
  }
}
const fetchUsersSuccess = function(response) {
  return {
    type: 'FETCH_USERS_SUCCESS',
    response
  }
}
export default function fetchUsers(authData) {
  return function(dispatch) {
    dispatch(fetchUsersRequest())

    return (
      fetch(
        '/api/v1/users.json', {
          method: 'GET',
          headers: {
            Authorization: 'Basic ' + btoa(authData)
          }
        }
      ).then(
        function(response) {
          const { status, statusText } = response
          if (status >= 400) {
            dispatch(fetchUsersFailure(response))
            throw new Error(`Fetch Users Error ${status}: ${statusText}`)
          }
          return response.json()
        }
      ).then(json => {
        console.log('fetchUsers json', json)
        dispatch(fetchUsersSuccess(json))
      })
    )
  }
}

 fetchUsers
