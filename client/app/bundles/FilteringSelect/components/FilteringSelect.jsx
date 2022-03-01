import React, { MouseEventHandler } from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router'
import { Label, Input, Errors } from 'rform'
import Select, {
  components,
  MultiValueGenericProps,
  MultiValueProps,
  OnChangeValue,
  Props,
} from 'react-select'

import {
  SortableContainer,
  SortableContainerProps,
  SortableElement,
  SortEndHandler,
  SortableHandle,
} from 'react-sortable-hoc'

function arrayMove(array, from, to) {
  const slicedArray = array.slice();
  slicedArray.splice(
    to < 0 ? array.length + to : to,
    0,
    slicedArray.splice(from, 1)[0]
  );
  return slicedArray;
}

const SortableMultiValue = SortableElement(
  (props) => {
    // this prevents the menu from being opened/closed when the user clicks
    // on a value to begin dragging it. ideally, detecting a click (instead of
    // a drag) would still focus the control and toggle the menu, but that
    // requires some magic with refs that are out of scope for this example
    const onMouseDown = (e) => {
      e.preventDefault();
      e.stopPropagation();
    };
    const innerProps = { ...props.innerProps, onMouseDown };
    return <components.MultiValue {...props} innerProps={innerProps} />;
  }
);

const SortableMultiValueLabel = SortableHandle(
  (props) => <components.MultiValueLabel {...props} />
);

const SortableSelect = SortableContainer(Select)

export default class FilteringSelect extends React.Component {
  constructor(props){
    super(props);

    this._renderSelect = this._renderSelect.bind(this)
  };
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
      classNameWithChanged,
      wrapperClassNameWithChanged,
      attribute,
      errorClassName,
      errors,
      label,
      onChange,
      value,
      multi,
      placeholder,
      children,
      disabled,
      options,
      isLoading,
      onInputChange,
      showSelect,
      formId,
      model,
    } = this.props


    return (
      <div className={wrapperClassNameWithChanged}>
        <Label
          formId={formId}
          model={model || 'generic'}
          attribute={attribute}
          content={label}
        />

        {showSelect &&
          this._renderSelect({
            multi,
            options,
            isLoading,
            onChange,
            onInputChange,
            value,
            placeholder,
            disabled,
            attribute,
            classNameWithChanged
          })}

        {children}

        <Errors
          className={errorClassName}
          attribute={attribute}
          errors={errors}
        />
      </div>
    )
  }

  _renderSelect({
    multi,
    options,
    isLoading,
    onChange,
    onInputChange,
    value,
    placeholder,
    disabled,
    attribute,
    classNameWithChanged
  }) {

    const existingIds = typeof value === 'string' ? value.split(',') : value
    const existingValues = Array.isArray(existingIds)
      ? existingIds.map((id) => options.find(({ value }) => value === id))
      : options.filter(({ value }) => value === existingIds)

    return (
      <SortableSelect
        useDragHandle
        // react-sortable-hoc props:
        axis="xy"
        onSortEnd={({ oldIndex, newIndex}) => onChange(arrayMove(existingValues, oldIndex, newIndex))}
        distance={4}
        // small fix for https://github.com/clauderic/react-sortable-hoc/pull/352:
        getHelperDimensions={({ node }) => node.getBoundingClientRect()}
        // react-select props:
        isMulti={multi}
        options={this.props.options}
        value={existingValues}
        onChange={onChange}
        components={{
          MultiValue: SortableMultiValue,
          MultiValueLabel: SortableMultiValueLabel,
        }}
        closeMenuOnSelect
        isClearable
        cacheOptions
        onInputChange={onInputChange}
      />
    );
  }
}

FilteringSelect.propTypes = {
  multi: PropTypes.bool,
}

FilteringSelect.defaultProps = {
  multi: false
}
