import { connect } from 'react-redux'
import isArray from 'lodash/isArray'
import merge from 'lodash/merge'
import settings from '../../../lib/settings'
import TableCell from '../components/TableCell'

const mapStateToProps = (state, ownProps) => {
  const { row, field } = ownProps

  let content = (field.relation == 'association')
    ? getContentFromAssociation(row, field) : row[field.field]
  const contentType = getTypeOfContent(content)
  // add contentType to every item in content-Array
  if (contentType == 'object' && isArray(content)) {
    content = content.map(item => merge(item, {type: getTypeOfContent(item)}))
  }

  return {
    content,
    contentType
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

function getContentFromAssociation(row, field) {
  const modelPath = field.model.split('.')
  for (let step of modelPath) {
    row = row && row[step] ? row[step] : undefined
  }
  if (!row) return null
  if (isArray(row)) {
    return row.map(singleObject => singleObject && singleObject[field.field])
  } else {
    return row[field.field]
  }
}

function getTypeOfContent(content) {
  let contentType = typeof content
  if (contentType == 'string') {
    if (timeStringRegex.test(content)) contentType = 'time'
  }
  return contentType
}

const timeStringRegex =
  /^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}.\d{3,}(\+\d{2}:\d{2})?/

export default connect(mapStateToProps, mapDispatchToProps)(TableCell)
