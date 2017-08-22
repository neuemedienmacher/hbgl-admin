import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { setupAction, updateAction } from 'rform'
import mapCollection from 'lodash/map'
import some from 'lodash/some'
import formObjectSelect from '../lib/formObjectSelect'
import generateFormId from '../lib/generateFormId'
import  { setUi, setUiLoaded } from '../../../Backend/actions/setUi'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import addEntities from '../../../Backend/actions/addEntities'
import Form from '../components/Form'
import { singularize } from '../../../lib/inflection'
import settings from '../../../lib/settings'

const mapStateToProps = (state, ownProps) => {
  const { model, editId, submodelKey } = ownProps
  const submodelPath = ownProps.submodelPath || []
  const formId = generateFormId(model, submodelPath, submodelKey, editId)
  const formSettings = state.settings[model]
  const formData = state.rform[formId] || {}
  const instance = state.entities[model] && state.entities[model][editId]
  const isAssignable =
    instance && instance['current-assignment-id'] !== undefined
  const afterSaveActiveKey = state.ui.afterSaveActiveKey
  const afterSaveActions =
    mapCollection(settings.AFTER_SAVE_ACTIONS, (value, key) => ({
      action: key, name: value, active: afterSaveActiveKey == key
    }))
  const formObjectClass = formObjectSelect(model, !!editId)
  const seedData = { fields: seedDataFromEntity(instance, formObjectClass) }

  let action = `/api/v1/${model}`
  let method = 'POST'
  const buttonData =
    buildActionButtonData(state, model, editId, instance, formObjectClass)

  // Changes in case the form updates instead of creating
  if (editId) {
    action += '/' + editId
    method = 'PUT'
  }

  return {
    seedData,
    action,
    method,
    formId,
    formObjectClass,
    instance,
    isAssignable,
    buttonData,
    afterSaveActions,
    afterSaveActiveKey,
  }
}

function seedDataFromEntity(entity, formObjectClass) {
  let fields = formObjectClass.genericFormDefaults || {}
  if (!entity) return fields

  for (let property of formObjectClass.properties) {
    fields[property] = entity[property]
  }

  for (let submodel of formObjectClass.submodels) {
    let submodelKey
    if (
      formObjectClass.submodelConfig[submodel].relationship == 'oneToOne'
    ) {
      submodelKey = submodel + '-id'
      if (!entity[submodelKey]) continue
      fields[submodel] = String(entity[submodelKey])
    } else {
      submodelKey = singularize(submodel) + '-ids'
      if (!entity[submodelKey]) continue
      fields[submodel] = entity[submodelKey].map(e => String(e))
    }
  }

  return fields
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps
  const { model, editId } = ownProps // , onSuccessfulSubmit

  const resetForm = (changes, response) => {
    const entity = changes[model][editId]
    const desiredFormData =
      seedDataFromEntity(entity, stateProps.formObjectClass)
    dispatch(setupAction(stateProps.formId, desiredFormData))
  }

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    afterResponse(_formId, changes, errors, _meta, response) {
      dispatch(setUiLoaded(true, 'GenericForm', model, editId))
      if (response.data && response.data.id) {
        const successMessages =
          ['Läuft bei dir!', 'Passt!', 'War jut', 'Ging durch']
        dispatch(addFlashMessage('success', successMessages[Math.floor(Math.random()*successMessages.length)]))
        // if (onSuccessfulSubmit)
        //   return onSuccessfulSubmit(response)

        dispatch(addEntities(changes))
        resetForm(changes, response)

        // after-save actions (redirects)
        if (stateProps.afterSaveActiveKey == 'to_edit') {
          browserHistory.push(`/${model}/${response.data.id}/edit`)
        } else if (stateProps.afterSaveActiveKey == 'to_table') {
          browserHistory.push(`/${model}`)
        } else if (stateProps.afterSaveActiveKey == 'to_new') {
          browserHistory.push(`/${model}/new`)
        }
      } else if (some(errors)) {
        dispatch(addFlashMessage('error', errorFlashMessage))
      }
    },

    afterError(_formId, response) {
      if (response.status < 500) return
      dispatch(
        addFlashMessage('error', 'Es ist ein Serverfehler aufgetreten.')
      )
      response.text().then((errorMessage) => console.error(errorMessage))
    },

    afterRequireValid(result) {
      if (result.valid) return
      dispatch(addFlashMessage('error', errorFlashMessage))
    },

    loadData(modelToLoad = model, id = editId) {
      if (modelToLoad && id)
        dispatch(loadAjaxData(`${modelToLoad}/${id}`, '', modelToLoad))
    },

    splitButtonMenuItemOnclick(eventKey, event) {
      dispatch(setUi('afterSaveActiveKey', eventKey))
    },

    onSubmitButtonClick(e) {
      const formId = stateProps.formId
      if(e.target.value){
        dispatch(updateAction(formId, 'commit', [], e.target.value))
      }
      return true
    },

    beforeSubmit() {
      dispatch(setUiLoaded(false, 'GenericForm', model, editId))
    }
  }
}
const errorFlashMessage =
  'Es gab Fehler beim Absenden des Formulars. Bitte korrigiere diese' +
  ' und versuche es erneut.'

function buildActionButtonData(state, model, editId, instance, formObject) {
  // start with default save button (might be extended)
  let buttonData = [{
    className: 'default',
    buttonLabel: 'Speichern',
    actionName: ''
  }]

  // iterate additional actions (e.g. state-changes) only for editing
  if (state.settings.actions[model]) {
    state.settings.actions[model].forEach(action => {
      if(state.entities['possible-events'] &&
         state.entities['possible-events'][model] &&
         state.entities['possible-events'][model][editId] &&
         state.entities['possible-events'][model][editId].data.includes(action)
      ){
        buttonData.push({
          className: model == 'divisions' ? 'warning' : 'default',
          buttonLabel: 'Speichern & ' + textForActionName(action, model),
          actionName: action
        })
      }
    })
  }

  // add special form-defined buttons
  if (formObject.additionalButtons) {
    buttonData.push(...formObject.additionalButtons(instance))
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
    return model == 'divisions' ?
      'als erledigt markieren' : 'Orga ist fertig (all done)'
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
