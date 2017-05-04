// DEPRECATED
import { connect } from 'react-redux'
import Inline from '../components/Inline'

const mapStateToProps = (state, ownProps) => {
  const { model, editId } = ownProps
  const formId = `GenericForm-Inline-${model}-${editId || 'new'}`

  return {
    formId
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(Inline)
