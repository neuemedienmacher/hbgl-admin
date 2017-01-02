import React, { PropTypes } from 'react'
import { Form, InputSet } from 'rform'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'

export default class FormInputs extends React.Component {
  render() {
    const {
      inputs, formId, blockedInputs, submodel, submodelIndex
    } = this.props

    return (
      <div className='FormInputs'>
        {
          inputs.map(this._renderInput.bind(this)(
            formId, blockedInputs, submodel, submodelIndex
          ))
        }
      </div>
    )
  }

  _renderInput(formId, blockedInputs, submodel, submodelIndex) {
    return (input, index) => {
      // Skip rendering blocked inputs
      if (blockedInputs.includes(input.attribute)) return

      switch(input.type) {
        case 'filtering-multiselect':
          return(
            <FilteringSelect multi key={index}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              submodel={submodel} submodelIndex={submodelIndex}
              formId={formId} type={input.type}
            />
          )
        case 'filtering-select':
          return(
            <FilteringSelect key={index}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              submodel={submodel} submodelIndex={submodelIndex}
              formId={formId} type={input.type}
            />
          )
        case 'creating-multiselect':
          return(
            <CreatingSelect multi key={index}
              input={input}
              submodel={submodel} submodelIndex={submodelIndex}
            />
          )
        case 'creating-select':
          return(
            <CreatingSelect key={index}
              input={input}
              submodel={submodel} submodelIndex={submodelIndex}
            />
          )
        default:
          return(
            <InputSet key={index}
              wrapperClassName='form-group' className='form-control'
              label={input.attribute} attribute={input.attribute}
              submodel={submodel} submodelIndex={submodelIndex}
              type={input.type}
            />
          )
      }
    }
  }
}
