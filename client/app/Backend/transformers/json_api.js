import isArray from 'lodash/isArray'
import merge from 'lodash/merge'

export default function transformJsonApi(json) {
  let object = {}
  if (isArray(json.data)) {
    object = extractArrayIntoObject(json.data, object)
  } else {
    object = extractDataPointIntoObject(json.data, object)
  }
  if (json.included) {
    object = extractArrayIntoObject(json.included, object)
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
