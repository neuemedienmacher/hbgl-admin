import isArray from 'lodash/isArray'
import merge from 'lodash/merge'

export default function transformJsonApi(object, apiResponse) {
  if (isArray(apiResponse.data)) {
    object = extractArrayIntoObject(apiResponse.data, object)
  } else {
    object = extractDataPointIntoObject(apiResponse.data, object)
  }
  if (apiResponse.included) {
    object = extractArrayIntoObject(apiResponse.included, object)
  }
  return object
}

function extractArrayIntoObject(array, object) {
  for (let datum of array) {
    object = extractDataPointIntoObject(datum, object)
  }
  return object
}

function extractDataPointIntoObject(datum, object) {
  if (!object[datum.type]) object[datum.type] = {}
  object[datum.type][datum.id] = merge(datum.attributes, {id: datum.id})
  return object
}
