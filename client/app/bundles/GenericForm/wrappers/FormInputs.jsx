import React, { Component, PropTypes } from 'react'
import FormInputs from '../containers/FormInputs'

export default class FormInputsWrapper extends Component {
  static contextTypes = {
    formObjectClass: PropTypes.func,
    model: PropTypes.string,
  }

  render() {
    return <FormInputs {...this.props} {...this.context} />
  }
}

