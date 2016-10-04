import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import routeForAction from '../../../lib/routeForAction'
import TableCell from '../components/TableCell'

const mapStateToProps = (state, ownProps) => {
  const { row, field } = ownProps

  const content = (field.relation == 'association')
    ? row[field.model][field.field] : row[field.field]

  let contentType = typeof content
  if (contentType == 'string') {
    if (timeStringRegex.test(content)) contentType = 'time'
  }

  return {
    content,
    contentType
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

const timeStringRegex =
  /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}\+\d{2}:\d{2}$/

export default connect(mapStateToProps, mapDispatchToProps)(TableCell)
