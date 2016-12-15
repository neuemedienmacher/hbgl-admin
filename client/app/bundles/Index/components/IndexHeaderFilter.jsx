import React, { PropTypes, Component } from 'react'
import IndexHeaderFilterOption from '../containers/IndexHeaderFilterOption'
import IndexHeaderOperatorOption from '../containers/IndexHeaderOperatorOption'

export default class IndexHeaderFilter extends Component {
  render() {
    const {
      options, onTrashClick, fields, operators, filterName, operatorName,
      filterValue, onFilterNameChange, onFilterValueChange,
      onFilterOperatorChange
    } = this.props

    return (
      <div>
        <div className='form-group'>
          <select
            className='form-control' value={filterName}
            onChange={onFilterNameChange}
          >
            {fields.map(field =>
              <IndexHeaderFilterOption key={field.name} field={field} />
            )}
          </select>
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
          <div className='input-group'>
            <input
              className='form-control' onChange={onFilterValueChange}
              value={filterValue}
            />
            <span className='input-group-btn'>
              <button className='btn' onClick={onTrashClick}>
                <span className='fui-trash' />
              </button>
            </span>
          </div>
        </div>
      </div>
    )
  }
}
