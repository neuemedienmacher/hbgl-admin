import React, { PropTypes } from 'react'
import FilteringSelect from '../wrappers/FilteringSelect'
import FormInputs from '../../GenericForm/wrappers/FormInputs'

export default class CreatingSelect extends React.Component {
  render() {
    const {
      multi, input, additionalSubmodelCount, onAdditionalObjectClick,
      additionalSubmodelForms, submodelName, formId
    } = this.props

    return (
      <div>
        <FilteringSelect multi={multi}
          wrapperClassName='form-group' className='form-control'
          label={input.attribute} attribute={input.attribute}
          formId={formId} type={input.type}
        >

          + {additionalSubmodelCount} weitere Objekte

          <button onClick={onAdditionalObjectClick}>
            ein weiteres neues Objekt hinzufügen
          </button>

          {additionalSubmodelForms.map(this._renderSubmodelForm.bind(this)(
            submodelName
          ))}
        </FilteringSelect>
      </div>
    )
  }

  _renderSubmodelForm(submodelName) {
    return (form, index) => {
      return(
        <div key={index} style={{border: '1px solid black'}}>
          <FormInputs submodel={submodelName} submodelIndex={index} />
        </div>
      )
    }
  }
}
