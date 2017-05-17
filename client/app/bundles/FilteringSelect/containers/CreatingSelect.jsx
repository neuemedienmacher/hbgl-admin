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

  return {
    hasSubmodelForm,
    submodelName,
    currentSelectValue,
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

    onSuccessfulSubmodelFormSubmit(response) {
      // hide submodel form
      onRemoveSubmodelFormClick()

      // add returned id to filtering select
      let newValue = response.data.id
      if (ownProps.multi)
        newValue = concat(stateProps.currentSelectValue, newValue)

      dispatch(
        updateAction(
          formId, input.attribute, ownProps.submodel, ownProps.submodelIndex,
          newValue
        )
      )

      // add display data for the filtering select
      dispatch(addForFilteringSelect(
        pluralize(input.resource || input.attribute.replace(/(-id|-ids)$/, '')),
        { value: response.data.id, label: response.data.attributes.label }
      ))
    }
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(CreatingSelect)
