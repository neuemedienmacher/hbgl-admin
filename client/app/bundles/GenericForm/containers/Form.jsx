import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { setupAction } from 'rform'
import concat from 'lodash/concat'
import formObjectSelect from '../lib/formObjectSelect'
import generateFormId from '../lib/generateFormId'
import addEntities from '../../../Backend/actions/addEntities'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Form from '../components/Form'
import { denormalizeStateEntity } from '../../../lib/denormalizeUtils'

const mapStateToProps = (state, ownProps) => {
  const { model, editId, submodelKey } = ownProps
  const submodelPath = ownProps.submodelPath || []
  const formId = generateFormId(model, submodelPath, submodelKey, editId)
  const formSettings = state.settings[model]
  const formData = state.rform[formId] || {}
  const instance = state.entities[model] && state.entities[model][editId]
  const isAssignable =
    instance && instance['current-assignment-id'] !== undefined

  const formObjectClass = formObjectSelect(model)

  let seedData = { fields: formObjectClass.genericFormDefaults || {} }

  let action = `/api/v1/${model}`
  let method = 'POST'
  let buttonData = buildActionButtonData(state, model, editId)

  // Changes in case the form updates instead of creating
  if (editId) {
    action += '/' + editId
    method = 'PUT'

    const stateEntity = state.entities[model][editId]
    let denormalizedEntity =
      denormalizeStateEntity(state.entities, model, editId)
    for (let property of formObjectClass.properties) {
      seedData.fields[property] = denormalizedEntity[property]
    }
  }

  return {
    seedData,
    action,
    method,
    formId,
    formObjectClass,
    instance,
    isAssignable,
    buttonData
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps

  const resetForm = () => {
    dispatch(
      setupAction(stateProps.formId, stateProps.seedData.fields)
    )
  }

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    afterResponse(response) {
      if (response.data && response.data.id) {
        const successMessages =
          ['Läuft bei dir!', 'Passt!', 'War jut', 'Ging durch']
        dispatch(addFlashMessage('success', successMessages[Math.floor(Math.random()*successMessages.length)]))
        if (ownProps.onSuccessfulSubmit)
          return ownProps.onSuccessfulSubmit(response)

        resetForm()
        // browserHistory.push(`/${ownProps.model}/${response.data.id}`)
      } else if (response.errors && response.errors.length) {
        dispatch(addFlashMessage('error', errorFlashMessage))
      }
    },

    afterRequireValid(result) {
      if (result.valid) return
      dispatch(addFlashMessage('error', errorFlashMessage))
      console.log(result)
    },

    loadData(model = ownProps.model, id = ownProps.editId) {
      if (model && id) {
        dispatchProps.dispatch(
          loadAjaxData(`${model}/${id}`, '', model)
        )
      }
    }
  }
}
const errorFlashMessage =
  'Es gab Fehler beim Absenden des Formulars. Bitte korrigiere diese' +
  ' und versuche es erneut.'

function buildActionButtonData(state, model, editId) {
  // start with default save button (might be extended)
  let buttonData = [{
    className: 'btn btn-default',
    buttonLabel: 'Speichern'
  }]
  // iterate additional actions (e.g. state-changes) only for editing
  if (state.settings.actions[model] && editId) {
    state.settings.actions[model].forEach(action => {
      if(state.entities['possible-events'] &&
         state.entities['possible-events'][model] &&
         state.entities['possible-events'][model][editId] &&
         state.entities['possible-events'][model][editId].data.includes(action)
       ){
        buttonData.push({
          className: model == 'divisions' ? 'btn btn-warning' : 'btn btn-default',
          buttonLabel: 'Speichern & ' + textForActionName(action, model),
          actionName: action
        })
      }
    })
  }
  return buttonData
}

// TODO: use translations
function textForActionName(action, model){
  switch(action) {
  case 'reinitialize':
    return 'Re-initialisieren'
  case 'complete':
    return 'als komplett markieren'
  case 'start_approval_process':
    return 'Approval starten'
  case 'approve':
    return 'Freischalten'
  case 'approve_with_deactivated_offers':
    return 'Freischalten (Comms-Only)'
  case 'approve':
    return 'Freischalten'
  case 'deactivate_internal':
    return 'Deaktivieren (Internal Feedback)'
  case 'deactivate_external':
    return 'Deaktivieren (External Feedback)'
  case 'website_under_construction':
    return 'Webseite im Aufbau'
  case 'mark_as_done':
    return model == 'divisions' ? 'als erledigt markieren' : 'Orga ist fertig (all done)'
  case 'mark_as_not_done':
    return 'als unvollständig markieren'
  default:
    return action
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(Form)
