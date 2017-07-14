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

export const addForFilteringSelect = (key, options) => ({
  type: 'LOAD_FOR_FILTERING_SELECT_SUCCESS',
  key,
  options,
})

export function loadForFilteringSelect(
  input, associatedModel, ids = ''
) {
  let path = `/api/v1/${associatedModel}?`
  if (input) path += `&query=${input}`
  if (ids) {
    for (let id of ids.split(',')){
      let arrayEntryParameter = {}
      arrayEntryParameter[`filters[id][]`] = id
      path += ('&' + encode(arrayEntryParameter))
    }
  }

  return function(dispatch) {
    dispatch(loadForFilteringSelectRequest(associatedModel, `${input},${ids}`))

    return fetch(path, {
      method: 'GET',
      credentials: 'same-origin'
    }).then(
      function(response) {
        const { status, statusText } = response
        if (status >= 400) {
          dispatch(loadForFilteringSelectFailure(response, associatedModel))
          throw new Error(
            `Load for FilteringSelect Error ${status}: ${statusText}`
          )
        }
        return response.json()
      }
    ).then(json => {
      dispatch(
        addForFilteringSelect(associatedModel, json.data.map(datum => (
          { value: datum.id, label: datum.attributes.label }
        )))
      )
    })
  }
}
