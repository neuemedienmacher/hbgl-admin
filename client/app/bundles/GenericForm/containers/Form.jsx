import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import addEntities from '../../../Backend/actions/addEntities'
import UserTeamFormObject from '../forms/UserTeamFormObject'
import DivisionFormObject from '../forms/DivisionFormObject'
import Form from '../components/Form'

const mapStateToProps = (state, ownProps) => {
  const { model, editId } = ownProps
  const formId = `GenericForm-${model + editId}`
  const formSettings = state.settings[model]
  const formData = state.rform[formId] || {}

  let seedData = {
    fields: {}
  }

  const formObjectClass = formObjectFor(model)
  const inputs = formObjectClass.properties.map(property => ({
    attribute: property,
    type: formObjectClass.formConfig[property].type
  }))

  let action = `/api/v1/${model}`
  let method = 'POST'

  // Changes in case the form updates instead of creating
  if (editId) {
    action += '/' + editId
    method = 'PUT'

    const stateEntity = state.entities[model][editId]
    for (let property of formObjectClass.properties) {
      seedData.fields[property] = stateEntity[property]
    }
  }

  return {
    inputs,
    seedData,
    action,
    method,
    formId,
    formObjectClass,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  handleResponse: (_formId, data) => dispatch(addEntities(data)),

  afterResponse(response) {
    if (response.data && response.data.id) {
      browserHistory.push(`/${ownProps.model}/${response.data.id}`)
    }
  }
})

function formObjectFor(model) {
  switch(model) {
  case 'user_teams':
    return UserTeamFormObject
  case 'divisions':
    return DivisionFormObject
  default:
    throw new Error(
      `Please provide a configuring FormObject for ${model} if you want to
      use the GenericForm bundle`
    )
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(Form)
