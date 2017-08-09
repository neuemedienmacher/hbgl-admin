import React, { PropTypes } from 'react'
import { Link } from 'react-router'
import { Label, Input, Errors } from 'rform'
import VirtualizedSelect from 'react-virtualized-select'
import ActionList from '../../ActionList/containers/ActionList'

export default class FilteringSelect extends React.Component {
  componentDidMount() {
    this.props.onMount()

    if (!!this.props.value) {
      this.props.onFirstValue(this.props.value)
    }
  }

  componentWillReceiveProps(nextProps) {
    if (!!nextProps.value && nextProps.value != this.props.value) {
      this.props.onFirstValue(nextProps.value)
    }
  }

  componentWillUnmount() {
    this.props.onUnmount()
  }

  render() {
    const {
      wrapperClassName, attribute, errorClassName, errors, label, loadOptions,
      onChange, value, multi, placeholder, children, disabled,
      options, isLoading, onInputChange, showSelect, formId, model,
    } = this.props

    return (
      <div className={wrapperClassName}>
        <Label
          formId={formId} model={model || 'generic'} attribute={attribute}
          content={label}
        />

        {showSelect && this._renderSelect(
          multi, options, isLoading, onChange, onInputChange, value,
          placeholder, disabled, attribute
        )}

        {children}

        <Errors
          className={errorClassName} attribute={attribute} errors={errors}
        />
      </div>
    )
  }

  _renderSelect(
    multi, options, isLoading, onChange, onInputChange, value, placeholder,
    disabled, attribute
  ) {
    return(
      <VirtualizedSelect multi={multi}
        options={options} isLoading={isLoading} onChange={onChange}
        onInputChange={onInputChange} value={value}
        placeholder={placeholder} disabled={disabled}
        valueRenderer={this.renderValue(attribute)}
      />
    )
  }

  renderValue(attribute) {
    return (valueObject) => {
      let entity
      if (['website', 'websites'].includes(attribute))
        entity = { url: valueObject.label } // label contains the url

      return(
        <span>
          {valueObject.label}
          <ActionList
            model={attribute} id={valueObject.value} entity={entity}
          />
        </span>
      )
    }
  }
}
