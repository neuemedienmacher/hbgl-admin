import React, { PropTypes } from 'react'
import { Label, Input, Errors } from 'rform'
import VirtualizedSelect from 'react-virtualized-select'

export default class FilteringSelect extends React.Component {
  componentDidMount() {
    this.props.onMount()
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.value === undefined && !!nextProps.value) {
      this.props.onFirstValue(nextProps.value)
    }
  }

  render() {
    const {
      wrapperClassName, attribute, errorClassName, errors, label, loadOptions,
      onChange, value, multi, placeholder,
      options, isLoading, onInputChange,
    } = this.props

    return (
      <div className={wrapperClassName}>
        <Label attribute={attribute} content={label} />

        <VirtualizedSelect multi={multi}
          options={options} isLoading={isLoading} onChange={onChange}
          onInputChange={onInputChange} value={value}
          placeholder={placeholder}
        />

        <Errors className={errorClassName} attribute={attribute} errors={errors} />
      </div>
    )
  }
}
