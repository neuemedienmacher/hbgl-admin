import React, { PropTypes, Component } from 'react'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'

export default class AssignmentsContainer extends Component {

  render() {
    const {
      heading, model, filter_query, scope
    } = this.props

    return (
      <div className="panel-group">
        <p>{heading}</p>
        <InlineIndex
          model={model} baseQuery={filter_query} identifier_addition={scope}
        />
      </div>
    )
  }
}
