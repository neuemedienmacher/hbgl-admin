import React, { PropTypes, Component } from 'react'
import AssignmentActions from '../containers/AssignmentActions'

export default class CurrentAssignment extends Component {

  render() {
    return (
      <div>
        {this.renderLoadingOrAssignment()}
        {this.renderActionsIfAssigned()}
      </div>
    )
  }

  renderLoadingOrAssignment() {
    const { assignment, involvedEntities, loaded } = this.props

    if (loaded) {
      return(
        <div className="assignment-head">
          <b>von:</b> {involvedEntities.creator},
          Team: {involvedEntities.creatorTeam}
          <br />
          <b>für:</b> {involvedEntities.receiver},
          Team: {involvedEntities.receiverTeam}
          <br />
          <b>Nachricht:</b> {assignment.message}
        </div>
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }

  renderActionsIfAssigned() {
    const { assignment, loaded, assignableDataLoad } = this.props

    if (loaded) {
      return (
        <AssignmentActions
          assignment={assignment} assignableDataLoad={assignableDataLoad}
        />
      )
    } else {return null}
  }
}
