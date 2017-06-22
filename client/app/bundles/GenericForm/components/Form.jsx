import React, { PropTypes } from 'react'
import { Form, InputSet, Input, Button } from 'rform'
import FormInputs from '../containers/FormInputs'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'
import AssignableContainer from '../../Assignable/containers/AssignableContainer'

export default class GenericFormForm extends React.Component {
  render() {
    const {
      seedData, action, method, formId, formObjectClass, submodelPath,
      afterResponse, handleResponse, model, nestingModel, instance, loadData,
      isAssignable, buttonData, afterRequireValid
    } = this.props

    return (
      this.renderFormWithOptionalAssignableContainer(
        (<div className='form FormWrapper'>
          <Form ajax requireValid
            method={method} className='form'
            formObjectClass={formObjectClass} model={model}
            action={action} id={formId} seedData={seedData}
            handleResponse={handleResponse} afterResponse={afterResponse}
            afterRequireValid={afterRequireValid}
          />
          <FormInputs
            model={model} formObjectClass={formObjectClass} formId={formId}
            nestingModel={nestingModel} submodelPath={submodelPath}
          />
          {this.renderButtons(formId, nestingModel, buttonData)}
        </div>), isAssignable, model, instance, loadData
      )
    )
  }

  renderFormWithOptionalAssignableContainer(
    form, isAssignable, model, instance, loadData
  ){
    if (isAssignable) {
      return (
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

  renderButtons(formId, nestingModel, buttonData) {
    if (nestingModel) return

    return(
      <div className='form button-container'>
        {buttonData.map((action, index) => {
          return (
            <Button
              className={action.className} type='submit' formId={formId}
              key={index} commit={action.actionName}
            >
              {action.buttonLabel}
            </Button>
          )
        })}
      </div>
    )
  }
}
