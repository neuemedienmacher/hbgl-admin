import { connect } from 'react-redux'
import EditTranslationRow from '../components/EditTranslationRow'

const mapStateToProps = (state, ownProps) => {
  const { property, formId } = ownProps

  const type = (property == 'name') ? 'string' : 'textarea'
  const length = (
    state.rform[formId] && state.rform[formId][property] &&
    state.rform[formId][property].length
  ) || 0

  return {
    type,
    length,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(EditTranslationRow)
