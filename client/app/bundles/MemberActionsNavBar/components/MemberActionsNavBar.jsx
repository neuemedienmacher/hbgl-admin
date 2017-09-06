import React from 'react'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import { LinkContainer, IndexLinkContainer } from 'react-router-bootstrap'

export default class MemberActionsNavBar extends React.Component {
  render() {
    const { actions, heading } = this.props

    if (!actions.length) return null

    return(
      <div className='MemberActionsNavBar'>
        <h3>{heading}</h3>
        <Nav bsStyle='pills'>
          {actions.map(action => this.renderLinkContainer(action))}
        </Nav>
      </div>
    )
  }

  renderLinkContainer(action) {
    if (action.target) {
      return(
        <NavItem key={action.text} href={action.href} target={action.target}>
          <span className={action.icon} /> {action.text}
        </NavItem>
      )
    }
    else{
      return(
        <IndexLinkContainer key={action.text} to={action.href}>
          <NavItem>
            <span className={action.icon} /> {action.text}
          </NavItem>
        </IndexLinkContainer>
      )
    }
  }
}
