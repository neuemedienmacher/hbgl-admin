import React, { PropTypes } from 'react'
import FilteringSelect from '../wrappers/FilteringSelect'
import FormInputs from '../../GenericForm/wrappers/FormInputs'
import Form from '../../GenericForm/containers/Form'

export default class CreatingSelect extends React.Component {
  render() {
    const {
      multi, input, hasSubmodelForm, onAddSubmodelFormClick,
      onRemoveSubmodelFormClick, submodelName, formId, model,
      onSuccessfulSubmodelFormSubmit
    } = this.props

    return (
      <div>
        <FilteringSelect multi={multi}
          wrapperClassName='form-group' className='form-control'
          label={input.attribute} attribute={input.attribute}
          formId={formId} type={input.type} resource={input.resource}
        >
          {this._renderAdditionalObjectButton(
            hasSubmodelForm, onAddSubmodelFormClick
          )}

          {this._renderSubmodelForm(
            hasSubmodelForm, model, submodelName, onRemoveSubmodelFormClick,
            onSuccessfulSubmodelFormSubmit
          )}
        </FilteringSelect>
      </div>
    )
  }

  _renderAdditionalObjectButton(hasSubmodelForm, clickHandler) {
    if (hasSubmodelForm) return
    return(
      <button onClick={clickHandler}>
        ein neues Objekt hinzufügen
      </button>
    )
  }

  _renderSubmodelForm(
    hasSubmodelForm, model, submodelName, removeClickHandler,
    successfulSubmitCallback
  ) {
    if (!hasSubmodelForm) return
    return(
      <div style={{border: '1px solid black'}}>
        <button onClick={removeClickHandler}>x</button>
        <Form
          model={submodelName} nestingModel={model}
          onSuccessfulSubmit={successfulSubmitCallback}
        />
      </div>
    )
  }
}
