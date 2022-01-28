import React, { Component } from 'react'
import PropTypes from 'prop-types'
import FilteringSelect from '../containers/FilteringSelect'

export default class FilteringSelectWrapper extends Component {
  static contextTypes = {
    formId: PropTypes.string,
  }

  render() {
    return <FilteringSelect {...this.context} {...this.props} />
  }
}
