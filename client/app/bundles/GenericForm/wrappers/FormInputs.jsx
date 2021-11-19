import React, { Component } from 'react'
import PropTypes from 'prop-types'
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
