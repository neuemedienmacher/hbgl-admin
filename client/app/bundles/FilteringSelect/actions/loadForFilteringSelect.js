import keys from 'lodash/keys'
import { singularize } from '../../../lib/inflection'
import { BELONGS_TO } from '../../../lib/constants'

const loadForFilteringSelectRequest = (key, input) => ({
  type: 'LOAD_FOR_FILTERING_SELECT_REQUEST',
  key,
  input,
})

const loadForFilteringSelectFailure = (error, key) => ({
  type: 'LOAD_FOR_FILTERING_SELECT_FAILURE',
  error,
  key,
})

export const addForFilteringSelect = (key, options) => ({
  type: 'LOAD_FOR_FILTERING_SELECT_SUCCESS',
  key,
  options,
})

/**
 * @param input
 * @param associatedModel
 * @param key
 * @param model
 * @param inverseRelationship
 * @param paramHash
 * @param ids
 */
export function loadForFilteringSelect(
  input,
  associatedModel,
  key,
  model = null,
  inverseRelationship = null,
  paramHash = {},
  ids = ''
) {
  let path = `/api/v1/${associatedModel}`

  if (ids) {
    paramHash.filters = paramHash.filters || {}
    paramHash.filters.id = ids.split(',')
  }

  if (input) {
    paramHash.query = input
  }

  // if (keys(filters).length) paramHash.filters = filters
  if (inverseRelationship === BELONGS_TO) {
    paramHash.filters = paramHash.filters || {}
    paramHash.filters[`${singularize(model)}_id`] = 'nil'
    paramHash.operators = paramHash.operators || {}
    paramHash.operators.interconnect = 'OR'
  }
  if (keys(paramHash).length) {
    path += `?${$.param(paramHash)}`
  }

  return function (dispatch) {
    dispatch(loadForFilteringSelectRequest(key, `${input},${ids}`))

    return fetch(path, {
      method: 'GET',
      credentials: 'same-origin',
    })
      .then((response) => {
        const { status, statusText } = response

        if (status >= 400) {
          dispatch(loadForFilteringSelectFailure(response, key))
          throw new Error(
            `Load for FilteringSelect Error ${status}: ${statusText}`
          )
        }
        return response.json()
      })
      .then((json) => {
        dispatch(
          addForFilteringSelect(
            key,
            json.data.map((datum) => ({
              value: datum.id,
              label: datum.attributes.label,
            }))
          )
        )
      })
  }
}
