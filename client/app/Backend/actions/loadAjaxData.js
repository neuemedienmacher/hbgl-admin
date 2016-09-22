import { encode } from 'querystring'

const loadAjaxDataRequest = function(key) {
  return {
    type: 'LOAD_AJAX_DATA_REQUEST',
    key
  }
}
const loadAjaxDataFailure = function(error, key) {
  return {
    type: 'LOAD_AJAX_DATA_FAILURE',
    error,
    key
  }
}
const loadAjaxDataSuccess = (response, key) => ({
  type: 'LOAD_AJAX_DATA_SUCCESS',
  response,
  key
})
export default function loadAjaxData(model, query, key) {
  const path = `/api/v1/${model}?${encode(query)}`

  return function(dispatch) {
    dispatch(loadAjaxDataRequest(key))

    return fetch(path, {
      method: 'GET',
      credentials: 'same-origin'
    }).then(
      function(response) {
        const { status, statusText } = response
        if (status >= 400) {
          dispatch(loadAjaxDataFailure(response, key))
          throw new Error(`Load Ajax Data Error ${status}: ${statusText}`)
        }
        return response.json()
      }
    ).then(json => {
      dispatch(loadAjaxDataSuccess(json, key))
    })
  }
}


