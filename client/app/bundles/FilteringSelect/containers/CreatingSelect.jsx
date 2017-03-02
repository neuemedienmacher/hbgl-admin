import { connect } from 'react-redux'
import { pluralize } from '../../../lib/inflection'
import { addSubmodelForm, removeSubmodelForm } from
  '../../../Backend/actions/changeFormData'
import CreatingSelect from '../components/CreatingSelect'

const mapStateToProps = (state, ownProps) => {
  const additionalSubmodelForms = (state.form[ownProps.formId] &&
    state.form[ownProps.formId].additionalSubmodelForms) || []
  const attribute = ownProps.input.attribute
  const hasSubmodelForm = additionalSubmodelForms.includes(attribute)
  const attributeWithoutId = attribute.replace(/_id(s?)/, '')
  const submodelName =
    attribute.match(/s$/) ? pluralize(attributeWithoutId) : attributeWithoutId

  return {
    hasSubmodelForm,
    submodelName,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps
  const { formId, input } = ownProps

  return {
    ...stateProps,
    ...ownProps,

    onAddSubmodelFormClick() {
      dispatch(addSubmodelForm(formId, input.attribute))
    },

    onRemoveSubmodelFormClick() {
      dispatch(removeSubmodelForm(formId, input.attribute))
    },
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(CreatingSelect)
