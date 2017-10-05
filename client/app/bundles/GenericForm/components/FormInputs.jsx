import React, { PropTypes } from 'react'
import { Form, Input, InputSet } from 'rform'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'

export default class FormInputs extends React.Component {
  static contextTypes = {
    disableUiElements: PropTypes.bool
  }

  // componentDidMount() {
  //   this.props.setValuesOfBlockedInputs()
  // }

  render() {
    const {
      inputs, formId, blockedInputs, model, formObjectClass, submodelPath,
      nonEditableState
    } = this.props

    return (
      <div className='FormInputs'>
        {
          inputs.map(this._renderInput.bind(this)(
            formId, blockedInputs, model, formObjectClass, submodelPath,
            nonEditableState
          ))
        }
      </div>
    )
  }

  _renderInput(
    formId, blockedInputs, model, formObjectClass, submodelPath, nonEditableState
  ) {
    const disabled = this.context.disableUiElements === undefined ?
                       false : this.context.disableUiElements || nonEditableState

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
              wrapperClassName='form-group' disabled={disabled} {...input}
            />
          )
        case 'filtering-select':
          return(
            <FilteringSelect key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              wrapperClassName='form-group' disabled={disabled} {...input}
            />
          )
        case 'creating-multiselect':
          return(
            <CreatingSelect multi key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              input={input} submodelPath={submodelPath} disabled={disabled}
              filters={input.filters}
            />
          )
        case 'creating-select':
          return(
            <CreatingSelect key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              input={input} submodelPath={submodelPath} disabled={disabled}
              filters={input.filters}
            />
          )
        default:
          return(
            <InputSet preventEnterSubmit key={index}
              formId={formId} model={model} formObjectClass={formObjectClass}
              wrapperClassName='form-group' className='form-control'
              attribute={input.attribute} label={input.label}
              type={input.type} options={input.options} disabled={disabled}
            />
          )
      }
    }
  }
}
