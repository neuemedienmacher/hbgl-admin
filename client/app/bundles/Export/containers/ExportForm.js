import { connect } from 'react-redux'
import { encode } from 'querystring'
import compact from 'lodash/compact'
import toPairs from 'lodash/toPairs'
import settings from '../../../lib/settings'
import ExportForm from '../components/ExportForm'

const mapStateToProps = (state, ownProps) => {
  const field_set =
    state.entities.field_sets && state.entities.field_sets[ownProps.model]
  const column_names = field_set && field_set.column_names || []
  const associations = toPairs(field_set && field_set.associations || {})

  const action = `/exports/${ownProps.model}?${encode(ownProps.params)}`

  return {
    associations,
    column_names,
    action,
    authToken: state.settings.authToken
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(ExportForm)
