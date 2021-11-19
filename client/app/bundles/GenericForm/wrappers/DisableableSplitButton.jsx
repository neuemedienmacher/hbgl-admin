import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { SplitButton } from 'react-bootstrap'

export default class DisableableSplitButton extends Component {
  static contextTypes = {
    disableUiElements: PropTypes.bool,
  }

  render() {
    const disabled =
      this.context.disableUiElements === undefined
        ? false
        : this.context.disableUiElements

    return <SplitButton {...this.props} disabled={disabled} />
  }
}
