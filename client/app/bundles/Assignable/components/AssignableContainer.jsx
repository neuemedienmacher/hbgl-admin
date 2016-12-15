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
    const { model, heading, may_edit } = this.props
    const panel_class = may_edit ? 'panel panel-info' : 'panel panel-warning'

    return (
      <div className='content Assignment'>
        <div key={model} className={panel_class}>
          <div key={`${model}-heading`} className="panel-heading show--panel">
            <b>{heading}</b>
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
    const { assignment, involved_entities, loaded } = this.props

    if (loaded) {
      return(
        <div>
          <b>von:</b> {involved_entities.creator}, Team: {involved_entities.creator_team}
          <br />
          <b>für:</b> {involved_entities.reciever}, Team: {involved_entities.reciever_team}
          <br />
          <b>Nachricht:</b> {assignment.message}
        </div>
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }

  renderActionsIfAssigned() {
    const { assignment, loaded, may_edit, assignableDataLoad } = this.props

    if (loaded) {
      return (
        <AssignmentActions
          assignment={assignment} assignableDataLoad={assignableDataLoad}
        />
      )
    } else {return null}
  }
}
