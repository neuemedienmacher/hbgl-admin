import React, { Component, PropTypes } from 'react'
import InlineCreate from '../containers/InlineCreate'

export default class InlineCreateWrapper extends Component {
  static contextTypes = {
    formId: PropTypes.string,
  }

  render() {
    return <InlineCreate {...this.props} {...this.context} />
  }
}

