import React, { PropTypes, Component } from 'react'
import IndexHeaderFilterOption from '../containers/IndexHeaderFilterOption'
import IndexHeaderOperatorOption from '../containers/IndexHeaderOperatorOption'

export default class IndexHeaderFilter extends Component {
  render() {
    const {
      options, onTrashClick, fields, operators, filterName, operatorName,
      onFilterNameChange, onFilterValueChange, onCheckboxChange,
      onFilterOperatorChange, filterType, nilChecked, range, filterValue,
      secondFilterValue, onSecondFilterValueChange
    } = this.props

    return (
      <div>
        <div className='form-group'>
          <div className="select-wrapper">
          <select
            className='form-control' value={filterName}
            onChange={onFilterNameChange}
          >
            {fields.map(field =>
              <IndexHeaderFilterOption key={field.name} field={field} />
            )}
          </select>
          </div>
          <div className="select-wrapper">
          <select
            className='form-control' value={operatorName}
            onChange={onFilterOperatorChange}
          >
            {operators.map(operator =>
              <IndexHeaderOperatorOption
                key={operator.value} operator={operator}
              />
            )}
          </select>
          <label>
            <input type="checkbox" name="nil" value="nil"
              onChange={onCheckboxChange} checked={nilChecked}
            />
            leer
          </label>
          </div>
          <div className='input-group'>
            <input
              className='form-control' onChange={onFilterValueChange}
              value={filterValue} type={filterType} disabled={nilChecked}
            />
            <input
              className='form-control' onChange={onSecondFilterValueChange}
              value={secondFilterValue} type={filterType} disabled={nilChecked}
              style={{visibility:range}}
            />
            <span className='input-group-btn'>
              <button className='btn' onClick={onTrashClick}>
                <i className="fa fa-trash" />
              </button>
            </span>
          </div>
        </div>
      </div>
    )
  }
}
