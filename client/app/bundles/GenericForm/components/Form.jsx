import React, { PropTypes } from 'react'
import { Form, InputSet, Input, Button, Errors } from 'rform'
import { MenuItem } from 'react-bootstrap'
import FormInputs from '../containers/FormInputs'
import ReadOnlyProperties from '../containers/ReadOnlyProperties'
import DisableableSplitButton from '../wrappers/DisableableSplitButton'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'
import AssignableContainer from '../../Assignable/containers/AssignableContainer'

export default class GenericFormForm extends React.Component {
  render() {
    const {
      seedData, action, method, formId, formObjectClass, submodelPath,
      afterResponse, model, nestingModel, instance, loadData,
      isAssignable, buttonData, afterRequireValid, afterSaveActions,
      beforeSubmit, splitButtonMenuItemOnclick, onSubmitButtonClick,
      afterError, formStateDidMount, editId, errorMessages
    } = this.props

    return(
      this.renderFormWithOptionalAssignableContainer(
        (<div className='form FormWrapper'>
          <Errors model={model} formId={formId} attribute='base' />
          <Form ajax requireValid preventEnterSubmit
            method={method} className='form'
            formObjectClass={formObjectClass} model={model}
            action={action} id={formId} seedData={seedData}
            afterResponse={afterResponse} afterError={afterError}
            afterRequireValid={afterRequireValid} beforeSubmit={beforeSubmit}
            formStateDidMount={formStateDidMount}
          />
          <FormInputs
            model={model} formObjectClass={formObjectClass} formId={formId}
            nestingModel={nestingModel} submodelPath={submodelPath}
            id={editId}
          />
          <ReadOnlyProperties
            instance={instance} formObjectClass={formObjectClass}
          />
          {this.renderButtons(
            formId, nestingModel, buttonData, afterSaveActions,
            splitButtonMenuItemOnclick, onSubmitButtonClick
          )}
          {this.renderNotice(errorMessages)}
        </div>), isAssignable, model, instance, loadData
      )
    )
  }

  renderFormWithOptionalAssignableContainer(
    form, isAssignable, model, instance, loadData
  ) {
    if (isAssignable) {
      return(
        <AssignableContainer
          assignable_type={model} assignable={instance}
          assignableDataLoad={loadData}
        >
          {form}
        </AssignableContainer>
      )
    } else {
      return(<div>{form}</div>)
    }
  }

  renderButtons(
    formId, nestingModel, buttonData, afterSaveActions,
    splitButtonMenuItemOnclick, onSubmitButtonClick
  ) {
    if (nestingModel) return

    return(
      <div className='form button-container'>
        {buttonData.map((action, index) => (
          <DisableableSplitButton dropup key={index}
            bsStyle={action.className} title={action.buttonLabel} form={formId}
            id={`split-button-basic-${index}`} value={action.actionName}
            type='submit' onSelect={splitButtonMenuItemOnclick}
            onClick={onSubmitButtonClick}
          >
            {afterSaveActions.map(i => (
              <MenuItem key={i.action} eventKey={i.action} active={i.active}>
                {i.name}
              </MenuItem>
            ))}
          </DisableableSplitButton>
        ))}
      </div>
    )
  }

  renderNotice(errorMessages) {
    if (errorMessages.length > 0) {
      return(
        <div className='missing-approval'>
          {errorMessages.map(function(e) {
            return e + ' '
          })}
        </div>
      )
    }
  }
}
