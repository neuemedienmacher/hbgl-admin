import React, { PropTypes, Component } from 'react'
import { FormControl } from 'react-bootstrap'

export default class ControlledSelectView extends Component {

  render() {
    return (
      <div className='select-wrapper'>
        <FormControl componentClass="select"
          defaultValue={this.props.selectedValue}
          key={this.props.uniqIdentifier} onChange={this.props.handleSelect}
        >
          {this.props.children.map( (child, index) => {
            return(
              <option value={child[0]} key={this.props.uniqIdentifier + index} >
                {child[1]}
              </option>
            )
          })}
        </FormControl>
      </div>
    )
  }
}
