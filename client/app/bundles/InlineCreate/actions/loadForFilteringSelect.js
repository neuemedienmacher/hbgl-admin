import { encode } from 'querystring'

const loadForFilteringSelectRequest = (key, input) => ({
  type: 'LOAD_FOR_FILTERING_SELECT_REQUEST',
  key,
  input
})

const loadForFilteringSelectFailure = (error, key) => ({
  type: 'LOAD_FOR_FILTERING_SELECT_FAILURE',
  error,
  key
})

const loadForFilteringSelectSuccess = (key, options) => ({
  type: 'LOAD_FOR_FILTERING_SELECT_SUCCESS',
  key,
  options,
})

// INFO: optional nextModel is required for different transformer (field_sets)
export default function loadForFilteringSelect(
  input, associatedModel
) {
  const path = `/api/v1/${associatedModel}?query=${input}`

  return function(dispatch) {
    dispatch(loadForFilteringSelectRequest(associatedModel, input))

    return fetch(path, {
      method: 'GET',
      credentials: 'same-origin'
    }).then(
      function(response) {
        const { status, statusText } = response
        if (status >= 400) {
          dispatch(loadForFilteringSelectFailure(response, associatedModel))
          throw new Error(`Load for FilteringSelect Error ${status}: ${statusText}`)
        }
        return response.json()
      }
    ).then(json => {
      dispatch(
        loadForFilteringSelectSuccess(associatedModel, json.data.map(datum => (
          { value: datum.id, label: datum.attributes.label }
        )))
      )
    })
  }
}
