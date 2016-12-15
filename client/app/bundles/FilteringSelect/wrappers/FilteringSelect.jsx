import React, { Component, PropTypes } from 'react'
import FilteringSelect from '../containers/FilteringSelect'

export default class FilteringSelectWrapper extends Component {
  static contextTypes = {
    formId: PropTypes.string,
  }

  render() {
    return <FilteringSelect {...this.props} {...this.context} />
  }
}

