import React, { PropTypes } from 'react'
import { Form, InputSet, Input } from 'rform'
import FormInputs from '../containers/FormInputs'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'
import AssignableContainer from '../../Assignable/containers/AssignableContainer'

export default class GenericFormForm extends React.Component {
  render() {
    const {
      seedData, action, method, formId, formObjectClass, submodelPath,
      afterResponse, handleResponse, model, nestingModel, instance, loadData,
      isAssignable
    } = this.props

    return (
      this.renderFormWithOptionalAssignableContainer(
        (<div className='form FormWrapper'>
          <Form ajax requireValid
            method={method} className='form'
            formObjectClass={formObjectClass} model={model}
            action={action} id={formId} seedData={seedData}
            handleResponse={handleResponse} afterResponse={afterResponse}
          />
          <FormInputs
            model={model} formObjectClass={formObjectClass} formId={formId}
            nestingModel={nestingModel} submodelPath={submodelPath}
          />
          {this.renderButton(formId, nestingModel)}
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

  renderButton(formId, nestingModel) {
    if (nestingModel) return

    return(
      <button className='btn btn-default' type='submit' form={formId}>
        Abschicken
      </button>
    )
  }
}
