import { connect } from 'react-redux'
import { updateAction } from 'rform'
import concat from 'lodash/concat'
import { registerSubmodelForm, unregisterSubmodelForm } from 'rform'
import generateFormId from '../../GenericForm/lib/generateFormId'
import { pluralize } from '../../../lib/inflection'
import { addForFilteringSelect } from '../actions/loadForFilteringSelect'
import CreatingSelect from '../components/CreatingSelect'

const mapStateToProps = (state, ownProps) => {
  const attribute = ownProps.input.attribute
  const additionalSubmodelForms = (state.rform[ownProps.formId] &&
    state.rform[ownProps.formId]._registeredSubmodelForms &&
    state.rform[ownProps.formId]._registeredSubmodelForms[attribute]) || []
  const hasSubmodelForm = !!additionalSubmodelForms.length
  const attributeWithoutId = attribute.replace(/-id(s?)/, '')
  const submodelName = pluralize(attributeWithoutId)
  const parentModels = concat(ownProps.submodelPath || [], ownProps.model)

  const formState = state.rform[ownProps.formId]
  const currentSelectValue = formState && formState[attribute]

  const showSelect = ownProps.multi || !hasSubmodelForm
  const showButton = ownProps.multi || !hasSubmodelForm && !currentSelectValue

  return {
    additionalSubmodelForms,
    submodelName,
    currentSelectValue,
    showSelect,
    showButton,
    parentModels,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps
  const { formId, input } = ownProps
  const { submodelName, parentModels, additionalSubmodelForms } = stateProps
  const submodelFormId = generateFormId(
    submodelName, parentModels, additionalSubmodelForms.length
  )

  return {
    ...stateProps,
    ...ownProps,

    onAddSubmodelFormClick() {
      dispatch(registerSubmodelForm(formId, input.attribute, submodelFormId))
    },

    onRemoveSubmodelFormClick() {
      dispatch(unregisterSubmodelForm(formId, input.attribute, submodelFormId))
    },
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(CreatingSelect)
