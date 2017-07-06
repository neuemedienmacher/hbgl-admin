import React, { PropTypes } from 'react'
import { Form, InputSet, Input, Button } from 'rform'
import { SplitButton, MenuItem } from 'react-bootstrap'
import FormInputs from '../containers/FormInputs'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'
import AssignableContainer from '../../Assignable/containers/AssignableContainer'

export default class GenericFormForm extends React.Component {
  render() {
    const {
      seedData, action, method, formId, formObjectClass, submodelPath,
      afterResponse, model, nestingModel, instance, loadData,
      isAssignable, buttonData, afterRequireValid, afterSaveActions,
      beforeSubmit
    } = this.props

    return (
      this.renderFormWithOptionalAssignableContainer(
        (<div className='form FormWrapper'>
          <Form ajax requireValid preventEnterSubmit
            method={method} className='form'
            formObjectClass={formObjectClass} model={model}
            action={action} id={formId} seedData={seedData}
            afterResponse={afterResponse}
            afterRequireValid={afterRequireValid} beforeSubmit={beforeSubmit}
          />
          <FormInputs
            model={model} formObjectClass={formObjectClass} formId={formId}
            nestingModel={nestingModel} submodelPath={submodelPath}
          />
          {this.renderButtons(formId, nestingModel, buttonData, afterSaveActions)}
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
      return (<div>{form}</div>)
    }
  }

  renderButtons(formId, nestingModel, buttonData, afterSaveActions) {
    if (nestingModel) return

    return(
      <div className='form button-container'>
        {buttonData.map((action, index) => (
          <SplitButton bsStyle={action.className} title={action.buttonLabel}
            key={index} id={`split-button-basic-${index}`} form={formId}
            value={action.actionName} type='submit' dropup
            onSelect={this.props.splitButtonMenuItemOnclick}
            onClick={this.props.onSubmitButtonClick}
          >
            {afterSaveActions.map(i => (
              <MenuItem key={i.action} eventKey={i.action} active={i.active}>
                {i.name}
              </MenuItem>
            ))}
          </SplitButton>
        ))}
      </div>
    )
  }
}
