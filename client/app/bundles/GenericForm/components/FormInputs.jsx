import React, { PropTypes } from 'react'
import { Form, Input, InputSet } from 'rform'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'

export default class FormInputs extends React.Component {
  componentDidMount() {
    this.props.setValuesOfBlockedInputs()
  }

  render() {
    const {
      inputs, formId, blockedInputs, model, formObjectClass, submodelPath
    } = this.props

    return (
      <div className='FormInputs'>
        {
          inputs.map(this._renderInput.bind(this)(
            formId, blockedInputs, model, formObjectClass, submodelPath
          ))
        }
      </div>
    )
  }

  _renderInput(formId, blockedInputs, model, formObjectClass, submodelPath) {
    return (input, index) => {
      // Skip rendering blocked inputs
      if (blockedInputs.includes(input.attribute)) {
        return(
          <Input key={index}
            formId={formId} model={model} formObjectClass={formObjectClass}
            labelText='' attribute={input.attribute} type='hidden'
          />
        )
      }

      switch(input.type) {
        case 'filtering-multiselect':
          return(
            <FilteringSelect multi key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              type={input.type} resource={input.resource}
            />
          )
        case 'filtering-select':
          return(
            <FilteringSelect key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              type={input.type} resource={input.resource}
            />
          )
        case 'creating-multiselect':
          return(
            <CreatingSelect multi key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              input={input} submodelPath={submodelPath}
            />
          )
        case 'creating-select':
          return(
            <CreatingSelect key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              input={input} submodelPath={submodelPath}
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
