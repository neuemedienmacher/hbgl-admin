import React, { PropTypes, Component } from 'react'
import IndexHeaderFilterOption from '../containers/IndexHeaderFilterOption'
import IndexHeaderFilterValueOption from '../containers/IndexHeaderFilterValueOption'
import IndexHeaderOperatorOption from '../containers/IndexHeaderOperatorOption'

export default class IndexHeaderFilter extends Component {
  componentWillReceiveProps(nextProps) {
    if (nextProps.model != this.props.model) {
      this.props.loadData(nextProps.model)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      options, onTrashClick, fields, operators, filterName, operatorName,
      onFilterNameChange, onFilterValueChange, onCheckboxChange,
      onFilterOperatorChange, filterType, nilChecked, range, filterValue,
      secondFilterValue, onSecondFilterValueChange, filterOptions
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
          {this.renderFields(this.props)}
        </div>
      </div>
    )
  }

  renderFields(props) {
    if (props.filterOptions && props.filterOptions.length > 0) {
      return(
        <div className='input-group'>
          <select
            className='form-control' onChange={props.onFilterValueChange}
            value={props.filterValue}
          >
            <option value="">-</option>
            {props.filterOptions.map(operator =>
              <IndexHeaderFilterValueOption
                key={operator} operator={operator}
              />
            )}
          </select>
          <span className='input-group-btn'>
            <button className='btn' onClick={props.onTrashClick}>
              <i className="fa fa-trash" />
            </button>
          </span>
        </div>
      )
    }
    else {
      return(
        <div className='input-group'>
          <input
            className='form-control' onChange={props.onFilterValueChange}
            value={props.filterValue} type={props.filterType}
            disabled={props.nilChecked}
          />
          <input
            className='form-control' onChange={props.onSecondFilterValueChange}
            value={props.secondFilterValue} type={props.filterType}
            disabled={props.nilChecked}
            style={{visibility:props.range}}
          />
          <span className='input-group-btn'>
            <button className='btn' onClick={props.onTrashClick}>
              <i className="fa fa-trash" />
            </button>
          </span>
        </div>
      )
    }
  }
}
