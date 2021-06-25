import { connect } from 'react-redux';
import { browserHistory } from 'react-router';
import { setupAction, updateAction } from 'rform';
import mapCollection from 'lodash/map';
import some from 'lodash/some';
import formObjectSelect from '../lib/formObjectSelect';
import generateFormId from '../lib/generateFormId';
import seedDataFromEntity from '../lib/seedDataFromEntity';
import { setUi, setUiLoaded } from '../../../Backend/actions/setUi';
import addFlashMessage from '../../../Backend/actions/addFlashMessage';
import loadAjaxData from '../../../Backend/actions/loadAjaxData';
import addEntities from '../../../Backend/actions/addEntities';
import Form from '../components/Form';
import settings from '../../../lib/settings';
import { denormalizeStateEntity } from '../../../lib/denormalizeUtils';

const errorFlashMessage =
  'Es gab Fehler beim Absenden des Formulars. Bitte korrigiere diese' +
  ' und versuche es erneut.';

function textForFailingGuard(guard) {
  switch (guard) {
    case 'orga_valid?':
      return 'Orga is not valid';
    case 'all_organizations_visible?':
      return 'Please check unapproved Orga(s)';
    case 'expiration_date_in_future?':
      return 'Offer has expired';
    default:
      return guard;
  }
}

function checkforErrors(state, model, id) {
  const errors = [];

  if (state.entities['possible-events'] &&
    state.entities['possible-events'][model] &&
    state.entities['possible-events'][model][id] &&
    state.entities['possible-events'][model][id]
  ) {
    state.entities['possible-events'][model][id].data.map(function (e) {
      if (e.failing_guards.length > 0) {
        errors.push(textForFailingGuard(e.failing_guards[0]));
      }
    });
  }
  return errors;
}

// TODO: use translations
function textForActionName(action, model) {
  switch (action) {
    case 'reinitialize':
      return 'Re-initialisieren';
    case 'complete':
      return 'als komplett markieren';
    case 'start_approval_process':
      return 'Approval starten';
    case 'approve':
      return 'Freischalten';
    case 'approve_with_deactivated_offers':
      return 'Freischalten (Comms-Only)';
    case 'approve':
      return 'Freischalten';
    case 'deactivate_internal':
      return 'Deaktivieren (Internal Feedback)';
    case 'deactivate_external':
      return 'Deaktivieren (External Feedback)';
    case 'website_under_construction':
      return 'Webseite im Aufbau';
    case 'mark_as_done':
      return model === 'divisions' ?
        'als erledigt markieren' : 'Orga ist fertig (all done)';
    case 'mark_as_not_done':
      return 'als unvollständig markieren';
    default:
      return action;
  }
}

function hasAtLeastOneSubmodelForm(formData) {
  if (formData && formData._registeredSubmodelForms) {
    for (const key in formData._registeredSubmodelForms) {
      if (
        formData._registeredSubmodelForms.hasOwnProperty(key) &&
        formData._registeredSubmodelForms[key].length
      ) {
        return true;
      }
    }
  }
  return false;
}

function buildActionButtonData(
  state, model, id, instance, formObject, formData, forceCreate
) {
  const changes = formData && formData._changes &&
    formData._changes.length || hasAtLeastOneSubmodelForm(formData);
  // start with default save button (might be extended)
  const buttonData = changes ? [{
    className: 'default',
    buttonLabel: 'Speichern',
    actionName: '',
  }] : [];

  // iterate additional actions (e.g. state-changes) only for editing
  if (state.settings.actions[model]) {
    const textPrefix = (changes ? 'Speichern & ' : '');

    if (!forceCreate &&
      state.entities['possible-events'] &&
      state.entities['possible-events'][model] &&
      state.entities['possible-events'][model][id] &&
      state.entities['possible-events'][model][id]
    ) {
      state.entities['possible-events'][model][id].data.map(function (e) {
        if (e.possible === true) {
          buttonData.push({
            className: model === 'divisions' ? 'warning' : 'default',
            buttonLabel: textPrefix + textForActionName(e.name, model),
            actionName: e.name,
          });
        }
      });
    }
  }

  // add special form-defined buttons
  if (formObject.additionalButtons) {
    buttonData.push(...formObject.additionalButtons(instance));
  }
  return buttonData;
}

const mapStateToProps = (state, ownProps) => {
  const {
    model, id, submodelKey, modifySeedData, formIdSpecification
  } = ownProps;
  const submodelPath = ownProps.submodelPath || [];
  const formId = generateFormId(
    model, submodelPath, submodelKey, id, formIdSpecification
  );
  const formSettings = state.settings[model];
  const formData = state.rform[formId] || {};
  const instance = denormalizeStateEntity(state.entities, model, id);
  const isAssignable =
    instance && instance['current-assignment-id'] !== undefined;
  const afterSaveActiveKey = state.ui.afterSaveActiveKey;
  const afterSaveActions =
    mapCollection(settings.AFTER_SAVE_ACTIONS, (value, key) => ({
      action: key, name: value, active: afterSaveActiveKey === key
    }));
  const formObjectClass = formObjectSelect(model, !!id);
  const seedData = {
    fields: seedDataFromEntity(instance, formObjectClass, modifySeedData)
  };

  let action = `/api/v1/${model}`;
  let method = 'POST';
  const buttonData = buildActionButtonData(
    state, model, id, instance, formObjectClass, formData, ownProps.forceCreate
  );
  const errorMessages = checkforErrors(state, model, id);

  // Changes in case the form updates instead of creating
  if (id && !ownProps.forceCreate) {
    action += '/' + id;
    method = 'PUT';
  }

  const newState = {
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
    errorMessages,
    id,
  };

  console.log('Form.jsx::props', newState);
  return newState;
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
});

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps;
  const { model, id } = ownProps; // , onSuccessfulSubmit

  const resetForm = (changes, response) => {
    const entity = changes[model][id];
    const desiredFormData = seedDataFromEntity(
      entity, stateProps.formObjectClass, ownProps.modifySeedData
    );
    dispatch(setupAction(stateProps.formId, desiredFormData));
  };

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    afterResponse(_formId, changes, errors, _meta, response) {
      dispatch(setUiLoaded(true, 'GenericForm', model, id));
      if (response.data && response.data.id) {
        const successMessages =
          ['Läuft bei dir!', 'Passt!', 'War jut', 'Ging durch'];
        dispatch(addFlashMessage('success', successMessages[Math.floor(Math.random() * successMessages.length)]));
        // if (onSuccessfulSubmit)
        //   return onSuccessfulSubmit(response)

        dispatch(addEntities(changes));
        resetForm(changes, response);

        // after-save actions (redirects)
        if (stateProps.afterSaveActiveKey === 'to_edit') {
          browserHistory.push(`/${model}/${response.data.id}/edit`);
        } else if (stateProps.afterSaveActiveKey === 'to_table') {
          browserHistory.push(`/${model}`);
        } else if (stateProps.afterSaveActiveKey === 'to_new') {
          browserHistory.push(`/${model}/new`);
        }
      } else if (some(errors)) {
        dispatch(addFlashMessage('error', errorFlashMessage));
      }
    },

    afterError(_formId, response) {
      if (response.status < 500) return;
      dispatch(
        addFlashMessage('error', 'Es ist ein Serverfehler aufgetreten.')
      );
      response.text().then((errorMessage) =>
        console.error(errorMessage.split('\n').splice(0, 30).join('\n'))
      );
    },

    afterRequireValid(result) {
      if (result.valid) return;
      dispatch(addFlashMessage('error', errorFlashMessage));
    },

    loadData(modelToLoad = model, id = id) {
      if (modelToLoad && id)
        dispatch(loadAjaxData(`${modelToLoad}/${id}`, '', modelToLoad));
    },

    splitButtonMenuItemOnclick(eventKey, event) {
      dispatch(setUi('afterSaveActiveKey', eventKey));
    },

    onSubmitButtonClick(e) {
      const formId = stateProps.formId;
      if (e.target.value) {
        dispatch(updateAction(formId, 'commit', [], e.target.value));
      }
      return true;
    },

    beforeSubmit() {
      dispatch(setUiLoaded(false, 'GenericForm', model, id));
    },
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(Form);
