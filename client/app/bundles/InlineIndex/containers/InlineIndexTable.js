import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import compact from 'lodash/compact'
import { analyzeFields } from '../../../lib/settingUtils'
import { denormalizeStateEntity } from '../../../lib/denormalizeUtils'
import InlineIndexTable from '../components/InlineIndexTable'

const mapStateToProps = (state, ownProps) => {
  if (!settings.index[ownProps.model])
    throw new Error(`Add settings for ${ownProps.model}`)

  const { model, identifier } = ownProps
  // specific inline_fields or fallback to normal index fields
  let settings_fields = settings.index[model].inline_fields ||
    settings.index[model].fields

  const fields = analyzeFields(settings_fields, model)
  const rows =
    state.ajax[identifier] ? compact(state.ajax[identifier].data.map(datum =>
      denormalizeStateEntity(state.entities, model, datum.id)
    )) : []

  let tbodyClass
  if (state.ajax.isLoading[identifier]) tbodyClass = 'loading'

  return {
    rows,
    fields,
    tbodyClass
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

export default connect(mapStateToProps, mapDispatchToProps)(InlineIndexTable)
