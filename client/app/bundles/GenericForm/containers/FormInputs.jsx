import { connect } from 'react-redux'
import intersection from 'lodash/intersection'
import { updateAction } from 'rform'
import { singularize } from '../../../lib/inflection'
import FormInputs from '../components/FormInputs'

const mapStateToProps = (state, ownProps) => {
  const { model, submodel, formObjectClass, nestingModel } = ownProps
  const properties = submodel ?
    formObjectClass.submodelConfig[submodel].properties :
    formObjectClass.properties
  let config = formObjectClass.formConfig
  if (submodel) config = config[submodel]

  const inputs = properties.map(property => ({
    attribute: property,
    type: config[property].type,
    options: config[property].options &&
      config[property].options.map(option => ({value: option, name: option})),
    resource: config[property].resource,
    filters: config[property].filters
  }))
  const blockedInputs = collectBlockedInputs(inputs, nestingModel)

  return {
    inputs,
    blockedInputs,
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
