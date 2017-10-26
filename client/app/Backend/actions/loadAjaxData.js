import { encode } from 'querystring'
import forEach from 'lodash/forEach'
import isArray from 'lodash/isArray'
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

// manually parses array filters and uses querystring.encode for any other input
function parseUrlParams(params) {
  let automaticEncodedParams = {}
  let manualParams = ''

  forEach(params, function(value, key) {
    // additional custom parsing can be added here
    if (isArray(value)) {
      value.map(filter_value => {
        // railsify query-syntax for arrays
        let arrayEntryParameter = {}
        arrayEntryParameter[`${key}[]`] = filter_value
        manualParams += '&' + encode(arrayEntryParameter)
      })
    } else {
      automaticEncodedParams[key] = value
    }
  });

  return encode(automaticEncodedParams) + manualParams
}

// INFO: optional nextModel is required for different transformer (field_sets)
export default function loadAjaxData(basePath, params, key, options = {}) {
  const { nextModel, onSuccess, onError } = options
  const transformer = options.transformer || transformJsonApi
  const path = `/api/v1/${basePath}?${parseUrlParams(params)}`

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
          onError && onError(response)
          throw new Error(`Load Ajax Data Error ${status}: ${statusText}`)
        }
        return response.json()
      }
    ).then(json => {
      dispatch(loadAjaxDataSuccess(json, key))
      dispatch(addEntities(transformer(json, nextModel)))
      onSuccess && onSuccess()
    })
  }
}
