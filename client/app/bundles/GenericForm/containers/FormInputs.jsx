import { connect } from 'react-redux'
import intersection from 'lodash/intersection'
import { updateAction } from 'rform'
import { singularize } from '../../../lib/inflection'
import FormInputs from '../components/FormInputs'

const mapStateToProps = (state, ownProps) => {
  const { model, submodel, formObjectClass, nestingModel, id } = ownProps
  const { submodelConfig, properties } = formObjectClass
  const config = formObjectClass.formConfig

  const inputs = properties.map(property => ({
    label:
      property + (formObjectClass.requiredInputs.includes(property) ? '*' : ''),
    attribute: property,
    type: config[property].type,
    options: config[property].options &&
      config[property].options.map(option => ({value: option, name: option})),
    resource: config[property].resource,
    filters: config[property].filters,
    inverseRelationship:
      submodelConfig[property] && submodelConfig[property].inverseRelationship
  }))
  const blockedInputs = collectBlockedInputs(inputs, nestingModel)
  let editableState =
    state.settings.editable_states[model] && state.entities[model] &&
    state.entities[model][id] && state.entities[model][id]['aasm-state'] &&
    state.settings.editable_states[model].includes(
      state.entities[model][id]['aasm-state']
    )
  const nonEditableState =
    editableState == undefined ? false : editableState == false

  return {
    inputs,
    blockedInputs,
    nonEditableState
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  // setValuesOfBlockedInputs() {
  //   for (let input of stateProps.blockedInputs) {
  //     dispatchProps.dispatch(
  //       updateAction(ownProps.formId, input, null, null, '_blocked', false)
  //     )
  //   }
  // }
})

function collectBlockedInputs(inputs, nestingModel) {
  let potentiallyBlockedInputs = []

  if (nestingModel) {
    const singularModel = singularize(nestingModel)
    potentiallyBlockedInputs.push(
      singularModel, `${singularModel}-id`, `${singularModel}-ids`
    )
  }

  const attributes = inputs.map( input => input.attribute )
  return intersection(attributes, potentiallyBlockedInputs)
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(FormInputs)
