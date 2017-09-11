import { connect } from 'react-redux'
import { encode } from 'querystring'
import compact from 'lodash/compact'
import toPairs from 'lodash/toPairs'
import settings from '../../../lib/settings'
import ExportForm from '../components/ExportForm'

const mapStateToProps = (state, ownProps) => {
  const fieldSet =
    state.entities['field-sets'] && state.entities['field-sets'][ownProps.model]
  const columns = fieldSet && fieldSet['columns'] || []
  const columnNames = columns.map(field => field.name)
  const associations = toPairs(fieldSet && fieldSet.associations || {})

  const action = `/exports/${ownProps.model}?${encode(ownProps.params)}`

  return {
    associations,
    columnNames,
    action,
    authToken: state.settings.authToken
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(ExportForm)
