import { connect } from 'react-redux'
import { updateAction } from 'rform'
import concat from 'lodash/concat'
import { pluralize } from '../../../lib/inflection'
import { addSubmodelForm, removeSubmodelForm } from
  '../../../Backend/actions/changeFormData'
import { addForFilteringSelect } from '../actions/loadForFilteringSelect'
import CreatingSelect from '../components/CreatingSelect'

const mapStateToProps = (state, ownProps) => {
  const additionalSubmodelForms = (state.form[ownProps.formId] &&
    state.form[ownProps.formId].additionalSubmodelForms) || []
  const attribute = ownProps.input.attribute
  const hasSubmodelForm = additionalSubmodelForms.includes(attribute)
  const attributeWithoutId = attribute.replace(/-id(s?)/, '')
  const submodelName = pluralize(attributeWithoutId)

  const formState = state.rform[ownProps.formId]
  const currentSelectValue = formState && formState[attribute]

  const showSelect = ownProps.multi || !hasSubmodelForm
  const showButton = ownProps.multi || !hasSubmodelForm && !currentSelectValue

  return {
    hasSubmodelForm,
    submodelName,
    currentSelectValue,
    showSelect,
    showButton,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps
  const { formId, input } = ownProps

  const onRemoveSubmodelFormClick = () =>
    dispatch(removeSubmodelForm(formId, input.attribute))

  return {
    ...stateProps,
    ...ownProps,

    onAddSubmodelFormClick() {
      dispatch(addSubmodelForm(formId, input.attribute))
    },

    onRemoveSubmodelFormClick,
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(CreatingSelect)
