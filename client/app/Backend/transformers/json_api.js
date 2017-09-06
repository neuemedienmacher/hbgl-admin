import isArray from 'lodash/isArray'
import merge from 'lodash/merge'

// INFO: nextModel was required for different transformer (field_sets) and it is
// simply ignored by this default transformer
export default function transformJsonApi(json, nextModel) {
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
  object[datum.type][datum.id] = merge(
    datum.attributes, {id: parseInt(datum.id), links: datum.links}
  )
  return object
}
