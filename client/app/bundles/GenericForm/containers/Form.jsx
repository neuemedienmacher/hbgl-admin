import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import formObjectSelect from '../lib/formObjectSelect'
import addEntities from '../../../Backend/actions/addEntities'
import Form from '../components/Form'

const mapStateToProps = (state, ownProps) => {
  const { model, editId } = ownProps
  const formId = `GenericForm-${model + (editId || '-new')}`
  const formSettings = state.settings[model]
  const formData = state.rform[formId] || {}

  let seedData = {
    fields: {}
  }

  const formObjectClass = formObjectSelect(model)

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

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(Form)
