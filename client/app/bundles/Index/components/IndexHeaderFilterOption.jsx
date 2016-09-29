import React, { PropTypes, Component } from 'react'

export default class IndexHeaderFilterOption extends Component {
  render() {
    const {
      value, displayName
    } = this.props

    return <option value={value}>{displayName}</option>
  }
}
