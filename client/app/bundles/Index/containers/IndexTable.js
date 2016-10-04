import { connect } from 'react-redux'
import compact from 'lodash/compact'
import forIn from 'lodash/forIn'
import clone from 'lodash/clone'
import settings from '../../../lib/settings'
import { analyzeFields } from '../../../lib/settingUtils'
import IndexTable from '../components/IndexTable'

const mapStateToProps = (state, ownProps) => {
  if (!settings.index[ownProps.model])
    throw new Error(`Add settings for ${ownProps.model}`)

  const { model } = ownProps
  const fields = analyzeFields(settings.index[model].fields, model)
  const rows = denormalizeResults(state.ajax.indexResults)

  let tbodyClass
  if (state.ajax.isLoading.indexResults) tbodyClass = 'loading'

  return {
    rows,
    fields,
    tbodyClass
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

function denormalizeResults(results) {
  return results.data.map(datum => {
    // get base attributes
    let denormalized = clone(datum.attributes)
    denormalized.id = datum.id

    // denormalize JSON API relationship information
    forIn(datum.relationships, (relationshipData, name) => {
      let relationshipAttributes = results.included.filter(included => {
        return included.id == relationshipData.data.id &&
          included.type == relationshipData.data.type
      })[0]
      denormalized[name] = relationshipAttributes.attributes
    })

    return denormalized
  })
}

export default connect(mapStateToProps, mapDispatchToProps)(IndexTable)
