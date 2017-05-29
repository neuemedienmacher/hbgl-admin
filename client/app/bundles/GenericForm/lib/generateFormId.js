import concat from 'lodash/concat'
import compact from 'lodash/compact'

export default function generateFormId(
  model, submodelPath, submodelKey, editId
) {
  return compact(concat(
    ['GenericForm'], submodelPath, model, submodelKey, editId || 'new'
  )).join('-')
}
