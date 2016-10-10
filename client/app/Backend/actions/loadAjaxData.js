import { encode } from 'querystring'
import transformJsonApi from '../transformers/json_api'
import addEntities from './addEntities'

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
  key,
})

// INFO: optional nextModel is required for different transformer (field_sets)
export default function loadAjaxData(
  basePath, query, key, transformer = transformJsonApi, nextModel = undefined
) {
  const path = `/api/v1/${basePath}?${encode(query)}`

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
      dispatch(addEntities(transformer(json, nextModel)))
    })
  }
}
