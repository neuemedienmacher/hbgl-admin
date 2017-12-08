import React, { PropTypes, Component } from 'react'
import MemberActionsNavBar from '../containers/MemberActionsNavBar'
import { IndexLinkContainer } from 'react-router-bootstrap'

export default class MemberAction extends Component {
  componentDidMount() {
    this.props.loadData()
    this.props.setupViewingSubscription()
  }

  componentWillUnmount() {
    this.props.removeViewingSubscription()
  }

  componentWillReceiveProps(nextProps) {
    // We need to reload the data when switching from one instance context to
    // another
    if (nextProps.model != this.props.model || nextProps.id != this.props.id){
      this.props.loadData(nextProps.model, nextProps.id, nextProps.view)
      this.props.changeView(nextProps)
    } else if (nextProps.view != this.props.view) {
      this.props.changeView(nextProps)
    }

    if (nextProps.entity._deleted)
      this.props.redirectOnDelete(nextProps.model)()

    // We need to reload the data on state-changes and done-changes because the
    // possible-events will have changed and the assignment may have changed
    if (
      this.props.entity['aasm-state'] && nextProps.entity['aasm-state'] &&
      this.props.entity['aasm-state'] != nextProps.entity['aasm-state'] ||
      nextProps.entity['done'] != undefined &&
      this.props.entity['done'] != nextProps.entity['done']
    )
      this.props.loadData(nextProps.model, nextProps.id, nextProps.view)
  }

  render() {
    const {
      model, id, location, view, ChildComponent, heading, viewingUsers,
      indexPath
    } = this.props

    return(
      <div className={`content MemberAction MemberAction-${view} ${model}`}>
        <IndexLinkContainer key={model} to={indexPath}>
          <a> &larr; zurück zu {model}</a>
        </IndexLinkContainer>
        <h3>{heading}</h3>
        <ul className='MemberAction-Viewers'>
          {viewingUsers.map(this.renderViewingUser.bind(this))}
        </ul>
        <MemberActionsNavBar model={model} id={id} location={location} />
        <ChildComponent model={model} id={id} />
      </div>
    )
  }

  renderViewingUser(view, index) {
    return(
      <li key={index} title={view.title} style={{background: view.color}}>
        {view.shorthand}
        {this.renderOptionalTabCount(view.tabcount)}
      </li>
    )
  }

  renderOptionalTabCount(count) {
    if (count < 2) return
    return(
      <span className='MemberAction-Viewers__tabcount badge badge-pill'>
        {count}
      </span>
    )
  }
}
