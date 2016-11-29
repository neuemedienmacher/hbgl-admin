import React, { Component, PropTypes } from 'react'
import MultiSelect from '../containers/MultiSelect'

export default class MultiSelectWrapper extends Component {
  static contextTypes = {
    formId: PropTypes.string,
  }

  render() {
    return <MultiSelect {...this.props} {...this.context} />
  }
}

