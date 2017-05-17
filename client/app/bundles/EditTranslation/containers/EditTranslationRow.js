import { connect } from 'react-redux'
import EditTranslationRow from '../components/EditTranslationRow'

const mapStateToProps = (state, ownProps) => {
  const { property, formId, mayEdit } = ownProps

  const type = (property == 'name') ? 'string' : 'textarea'
  const content = state.rform[formId] && state.rform[formId][property]
  const length = ( content && content.length ) || 0

  return {
    type,
    length,
    content
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(EditTranslationRow)
