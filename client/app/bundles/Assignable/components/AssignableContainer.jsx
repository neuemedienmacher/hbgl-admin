import React, { PropTypes, Component } from 'react'

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
          von: <b>{involved_entities.creator}, Team: {involved_entities.creator_team}</b>
          <br />
          für: <b>{involved_entities.reciever}, Team: {involved_entities.reciever_team}</b>
          <br />
          Nachricht: <b>{assignment.message}</b>
        </div>
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }
}
