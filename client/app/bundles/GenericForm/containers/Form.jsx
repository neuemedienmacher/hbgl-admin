import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { setupAction } from 'rform'
import concat from 'lodash/concat'
import formObjectSelect from '../lib/formObjectSelect'
import generateFormId from '../lib/generateFormId'
import addEntities from '../../../Backend/actions/addEntities'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import Form from '../components/Form'

const mapStateToProps = (state, ownProps) => {
  const { model, editId, submodelKey } = ownProps
  const submodelPath = ownProps.submodelPath || []
  const formId = generateFormId(model, submodelPath, submodelKey, editId)
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
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    handleResponse: (_formId, data, serverErrors) => {
      if (!serverErrors || !serverErrors.length) {
        dispatch(addEntities(data))
      } else {
        console.log(serverErrors)
        for (let error of serverErrors) {
          let message = error.source.pointer + ': ' + error.title
          dispatch(addFlashMessage('error', message))
        }
      }
    },

    afterResponse(response) {
      if (response.data && response.data.id) {
        dispatch(addFlashMessage('success', 'Läuft bei dir!'))
        if (ownProps.onSuccessfulSubmit)
          return ownProps.onSuccessfulSubmit(response)

        dispatch(setupAction(stateProps.formId, {})) // reset form
        // browserHistory.push(`/${ownProps.model}/${response.data.id}`)
      } else if (response.errors && response.errors.length) {
        for (let error of response.errors) {
          let message = error.source.pointer + ': ' + error.title
          dispatch(addFlashMessage('error', message))
        }
      }
    }
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(Form)
