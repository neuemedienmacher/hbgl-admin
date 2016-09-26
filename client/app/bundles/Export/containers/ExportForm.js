import { connect } from 'react-redux'
import compact from 'lodash/compact'
import settings from '../../../lib/settings'
import ExportForm from '../components/ExportForm'

const mapStateToProps = (state, ownProps) => {
  // if (!settings.index[ownProps.model])
  //   throw new Error(`Add settings for ${ownProps.model}`)
  //
  // const fields = settings.index[ownProps.model].fields
  // const resultData = state.ajax.indexResults
  // const resultIds = resultData.data.map(datum => datum.id)
  // const allOfModel = state[ownProps.model]
  // const rows = allOfModel ? compact(resultIds.map(id => allOfModel[id])) : []
  //
  // let tbodyClass
  // if (state.ajax.isLoading.indexResults) tbodyClass = 'loading'


  console.log(state)
  const field_set = state.ajax.field_sets && state.ajax.field_sets[ownProps.model]
  const column_names = field_set && field_set.column_names || []
  const associations = field_set && Object.keys(field_set.associations) || []

  return {
    column_names,
    associations
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(ExportForm)
