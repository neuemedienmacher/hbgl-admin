import React, { PropTypes } from 'react'
import { Form, InputSet } from 'rform'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'

export default class FormInputs extends React.Component {
  render() {
    const {
      inputs, formId, blockedInputs, model, formObjectClass
    } = this.props

    return (
      <div className='FormInputs'>
        {
          inputs.map(this._renderInput.bind(this)(
            formId, blockedInputs, model, formObjectClass
          ))
        }
      </div>
    )
  }

  _renderInput(formId, blockedInputs, model, formObjectClass) {
    return (input, index) => {
      // Skip rendering blocked inputs
      if (blockedInputs.includes(input.attribute)) return

      switch(input.type) {
        case 'filtering-multiselect':
          return(
            <FilteringSelect multi key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              type={input.type}
            />
          )
        case 'filtering-select':
          return(
            <FilteringSelect key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              type={input.type}
            />
          )
        case 'creating-multiselect':
          return(
            <CreatingSelect multi key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              input={input}
            />
          )
        case 'creating-select':
          return(
            <CreatingSelect key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              input={input}
            />
          )
        default:
          return(
            <InputSet key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              type={input.type} options={input.options}
            />
          )
      }
    }
  }
}
