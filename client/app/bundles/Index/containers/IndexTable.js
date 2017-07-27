import { connect } from 'react-redux'
import compact from 'lodash/compact'
import settings from '../../../lib/settings'
import { analyzeFields } from '../../../lib/settingUtils'
import { denormalizeStateEntity } from '../../../lib/denormalizeUtils'
import IndexTable from '../components/IndexTable'

const mapStateToProps = (state, ownProps) => {
  const { model } = ownProps
  if (!settings.index[model])
    throw new Error(`Add settings for ${model}`)

  const fields = analyzeFields(settings.index[model].fields, model)
  const rows = compact(state.ajax.indexResults.data.map(datum =>
    denormalizeStateEntity(state.entities, model, datum.id)
  ))

  let tbodyClass
  if (state.ajax.isLoading.indexResults) tbodyClass = 'loading'

  return {
    rows,
    fields,
    tbodyClass
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(IndexTable)
