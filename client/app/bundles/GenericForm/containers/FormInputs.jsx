import { connect } from 'react-redux'
import FormInputs from '../components/FormInputs'

const mapStateToProps = (state, ownProps) => {
  const { model, submodel, formObjectClass } = ownProps
  const properties = submodel ?
    formObjectClass.submodelConfig[submodel].properties :
    formObjectClass.properties
  let config = formObjectClass.formConfig
  if (submodel) config = config[submodel]

  const inputs = properties.map(property => ({
    attribute: property,
    type: config[property].type,
    options: config[property].options &&
      config[property].options.map(option => ({value: option, name: option}))
  }))
  const blockedInputs = collectBlockedInputs(submodel)

  return {
    inputs,
    blockedInputs,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
})

function collectBlockedInputs(model, submodel) {
  let inputs = []

  if (submodel) {
    inputs.push(`${model}_id`)
  }

  return inputs
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(FormInputs)
