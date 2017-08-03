import React, { PropTypes } from 'react'
import FilteringSelect from '../wrappers/FilteringSelect'
import FormInputs from '../../GenericForm/wrappers/FormInputs'
import Form from '../../GenericForm/containers/Form'

export default class CreatingSelect extends React.Component {
  render() {
    const {
      multi, input, additionalSubmodelForms, onAddSubmodelFormClick,
      onRemoveSubmodelFormClick, submodelName, formId, model, showSelect,
      showButton, parentModels, disabled
    } = this.props

    return (
      <div>
        <FilteringSelect multi={multi}
          wrapperClassName='form-group' className='form-control'
          formId={formId} showSelect={showSelect} model={model}
          disabled={disabled} label={input.attribute} {...input}
        >
          {showButton &&
            this._renderAdditionalObjectButton(onAddSubmodelFormClick, disabled)}

          {additionalSubmodelForms.map(this._renderSubmodelForms(
            model, submodelName, parentModels, onRemoveSubmodelFormClick))}
        </FilteringSelect>
      </div>
    )
  }

  _renderAdditionalObjectButton(addHandler, disabled) {
    return(
      <button disabled={disabled} onClick={addHandler}>
        ein neues Objekt hinzufügen
      </button>
    )
  }

  _renderSubmodelForms(model, submodelName, parentModels, removeClickHandler) {
    return (formId, index) => {
      return(
        <div style={{border: '1px solid black'}} key={index}>
          <button onClick={removeClickHandler(formId)}>x</button>
          <Form preventEnterSubmit
            formId={formId} model={submodelName} nestingModel={model}
            submodelPath={parentModels} submodelKey={index}
          />
        </div>
      )
    }
  }
}
