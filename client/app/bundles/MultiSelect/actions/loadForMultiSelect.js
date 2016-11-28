import { encode } from 'querystring'

const loadForMultiSelectRequest = (key, input) => ({
  type: 'LOAD_FOR_MULTI_SELECT_REQUEST',
  key,
  input
})

const loadForMultiSelectFailure = (error, key) => ({
  type: 'LOAD_FOR_MULTI_SELECT_FAILURE',
  error,
  key
})

const loadForMultiSelectSuccess = (key, options) => ({
  type: 'LOAD_FOR_MULTI_SELECT_SUCCESS',
  key,
  options,
})

// INFO: optional nextModel is required for different transformer (field_sets)
export default function loadForMultiSelect(
  input, associatedModel
) {
  const path = `/api/v1/${associatedModel}?query=${input}`

  return function(dispatch) {
    dispatch(loadForMultiSelectRequest(associatedModel, input))

    return fetch(path, {
      method: 'GET',
      credentials: 'same-origin'
    }).then(
      function(response) {
        const { status, statusText } = response
        if (status >= 400) {
          dispatch(loadForMultiSelectFailure(response, associatedModel))
          throw new Error(`Load for MultiSelect Error ${status}: ${statusText}`)
        }
        return response.json()
      }
    ).then(json => {
      dispatch(
        loadForMultiSelectSuccess(associatedModel, json.data.map(datum => (
          { value: datum.id, label: datum.attributes.label }
        )))
      )
    })
  }
}
