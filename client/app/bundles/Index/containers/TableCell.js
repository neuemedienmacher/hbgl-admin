import { connect } from 'react-redux'
import isArray from 'lodash/isArray'
import settings from '../../../lib/settings'
import TableCell from '../components/TableCell'

const mapStateToProps = (state, ownProps) => {
  const { row, field } = ownProps

  const content = (field.relation == 'association')
    ? getContentFromAssociation(row, field) : row[field.field]

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

function getContentFromAssociation(row, field) {
  const associationData = row[field.model]
  if (!associationData) return null
  if (isArray(associationData)) {
    return associationData.map(singleObject => singleObject[field.field])
  } else {
    return associationData[field.field]
  }
}

const timeStringRegex =
  /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}\+\d{2}:\d{2}$/

export default connect(mapStateToProps, mapDispatchToProps)(TableCell)
