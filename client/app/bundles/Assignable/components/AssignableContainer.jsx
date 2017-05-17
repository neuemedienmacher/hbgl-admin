import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import AssignmentActions from '../containers/AssignmentActions'

export default class AssignableContainer extends Component {
  componentWillReceiveProps(nextProps) {
    if (nextProps.model != this.props.model || nextProps.id != this.props.id) {
      this.props.loadData(nextProps.model, nextProps.id)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const { model, heading, mayEdit } = this.props
    const panelClass = mayEdit ? 'panel panel-info' : 'panel panel-warning'

    return (
      <div className='content Assignment'>
        <div key={model} className={panelClass}>
          <div key={`${model}-heading`} className="panel-heading show--panel">
            {heading}
          </div>
          <div key={name} className="panel-body show--panel">
            {this.renderLoadingOrAssignment()}
            {this.renderActionsIfAssigned()}
          </div>
        </div>
      </div>
    )
  }

  renderLoadingOrAssignment() {
    const { assignment, involvedEntities, loaded } = this.props

    if (loaded) {
      return(
        <div>
          <b>von:</b> {involvedEntities.creator}, Team: {involvedEntities.creatorTeam}
          <br />
          <b>für:</b> {involvedEntities.receiver}, Team: {involvedEntities.receiverTeam}
          <br />
          <b>Nachricht:</b> {assignment.message}
        </div>
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }

  renderActionsIfAssigned() {
    const { assignment, loaded, mayEdit, assignableDataLoad } = this.props

    if (loaded) {
      return (
        <AssignmentActions
          assignment={assignment} assignableDataLoad={assignableDataLoad}
        />
      )
    } else {return null}
  }
}
