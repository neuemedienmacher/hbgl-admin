import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import { analyzeFields, denormalizeIndexResults } from '../../../lib/settingUtils'
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
    state.ajax[identifier] ? denormalizeIndexResults(state.ajax[identifier]) : []

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
