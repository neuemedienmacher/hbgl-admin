import { connect } from 'react-redux'
import compact from 'lodash/compact'
import settings from '../../../lib/settings'
import { analyzeFields, denormalizeIndexResults } from '../../../lib/settingUtils'
import IndexTable from '../components/IndexTable'

const mapStateToProps = (state, ownProps) => {
  if (!settings.index[ownProps.model])
    throw new Error(`Add settings for ${ownProps.model}`)

  const { model, identifier } = ownProps
  // specific inline_fields or fallback to normal index fields
  let settings_fields = settings.index[model].inline_fields ||
    settings.index[model].fields

  const fields = analyzeFields(settings.index[model].fields, model)
  const rows = denormalizeIndexResults(state.ajax.indexResults)

  let tbodyClass
  if (state.ajax.isLoading.indexResults) tbodyClass = 'loading'

  return {
    rows,
    fields,
    tbodyClass
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

export default connect(mapStateToProps, mapDispatchToProps)(IndexTable)
