import { connect } from 'react-redux'
import forIn from 'lodash/forIn'
import clone from 'lodash/clone'
import settings from '../../../lib/settings'
import { analyzeFields } from '../../../lib/settingUtils'
import InlineIndexTable from '../components/InlineIndexTable'

const mapStateToProps = (state, ownProps) => {
  if (!settings.index[ownProps.model])
    throw new Error(`Add settings for ${ownProps.model}`)

  const { model, identifier } = ownProps
  // specific inline_fields or fallback to normal index fields
  let settings_fields = settings.index[model].inline_fields ||
    settings.index[model].fields

  const fields = analyzeFields(settings_fields, model)
  const rows = state.ajax[identifier] ? denormalizeResults(state.ajax[identifier]) : []

  let tbodyClass
  if (state.ajax.isLoading[identifier]) tbodyClass = 'loading'


  return {
    rows,
    fields,
    tbodyClass
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

// TODO: extract this function (DRY)
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

export default connect(mapStateToProps, mapDispatchToProps)(InlineIndexTable)
