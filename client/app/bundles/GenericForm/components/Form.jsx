import React, { PropTypes } from 'react'
import { Form, InputSet, Input } from 'rform'
import FormInputs from '../containers/FormInputs'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'

export default class GenericFormForm extends React.Component {
  render() {
    const {
      seedData, action, method, formId, formObjectClass, submodelPath,
      afterResponse, handleResponse, model, nestingModel,
    } = this.props

    return (
      <div className='form FormWrapper'>
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
      </div>
    )
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
