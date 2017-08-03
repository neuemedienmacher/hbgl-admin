import { encode } from 'querystring'
import keys from 'lodash/keys'
import { singularize } from '../../../lib/inflection'

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
  input, associatedModel, model = null, inverseRelationship = null,
  filters = {}, ids = ''
) {
  let path = `/api/v1/${associatedModel}`
  let paramHash = {}

  if (ids) filters.id = ids.split(',')
  if (input) paramHash.query = input
  if (keys(filters).length) paramHash.filters = filters
  if (inverseRelationship == 'belongsTo') {
    paramHash.filters = paramHash.filters || {}
    paramHash.filters[singularize(model) + '_id'] = 'nil'
    paramHash.operators = paramHash.operators || {}
    paramHash.operators.interconnect = 'OR'
  }
  if (keys(paramHash).length) path += '?' + $.param(paramHash)

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
