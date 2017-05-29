import React, { PropTypes } from 'react'
import FilteringSelect from '../wrappers/FilteringSelect'
import FormInputs from '../../GenericForm/wrappers/FormInputs'
import Form from '../../GenericForm/containers/Form'

export default class CreatingSelect extends React.Component {
  render() {
    const {
      multi, input, additionalSubmodelForms, onAddSubmodelFormClick,
      onRemoveSubmodelFormClick, submodelName, formId, model, showSelect,
      showButton, parentModels
    } = this.props

    return (
      <div>
        <FilteringSelect multi={multi}
          wrapperClassName='form-group' className='form-control'
          label={input.attribute} attribute={input.attribute}
          formId={formId} type={input.type} resource={input.resource}
          showSelect={showSelect}
        >
          {showButton &&
            this._renderAdditionalObjectButton(onAddSubmodelFormClick)}

          {additionalSubmodelForms.map(this._renderSubmodelForms(
            model, submodelName, parentModels, onRemoveSubmodelFormClick))}
        </FilteringSelect>
      </div>
    )
  }

  _renderAdditionalObjectButton(addHandler) {
    return(
      <button onClick={addHandler}>
        ein neues Objekt hinzufügen
      </button>
    )
  }

  _renderSubmodelForms(model, submodelName, parentModels, removeClickHandler) {
    return (_, index) => {
      return(
        <div style={{border: '1px solid black'}} key={index}>
          <button onClick={removeClickHandler}>x</button>
          <Form
            model={submodelName} nestingModel={model}
            submodelPath={parentModels} submodelKey={index}
          />
        </div>
      )
    }
  }
}
