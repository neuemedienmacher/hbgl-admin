import React, { PropTypes, Component } from 'react'
import IndexHeaderFilterOption from '../containers/IndexHeaderFilterOption'

export default class IndexHeaderFilter extends Component {
  render() {
    const {
      options, onTrashClick, fields, filterName, filterValue,
      onFilterNameChange, onFilterValueChange,
    } = this.props

    return (
      <div>
        <div className='form-group'>
          <select
            className='form-control' value={filterName}
            onChange={onFilterNameChange}
          >
            {fields.map(field =>
              <IndexHeaderFilterOption key={field.field} field={field} />
            )}
          </select>
          <div className='input-group'>
            <input
              className='form-control' placeholder='ist gleich…'
              onChange={onFilterValueChange} value={filterValue}
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
