import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Inline from '../containers/Inline';

export default class InlineWrapper extends Component {
  static contextTypes = {
    formId: PropTypes.string,
  }

  render() {
    return <Inline {...this.props} {...this.context} />
  }
}

