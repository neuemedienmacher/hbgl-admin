import React from 'react'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import { LinkContainer, IndexLinkContainer } from 'react-router-bootstrap'

export default class MemberActionsNavBar extends React.Component {
  render() {
    const { actions } = this.props

    return(
      <div className='MemberActionsNavBar'>
        <Nav bsStyle='pills'>
          {actions.map(action => this.renderLinkContainer(action))}
        </Nav>
      </div>
    )
  }

  renderLinkContainer(action) {
    if (action.target) { // is external link
      return(
        <NavItem key={action.text} href={action.href} target={action.target}>
          <span className={action.icon} /> {action.text}
        </NavItem>
      )
    } else { // is internal link
      return(
        <IndexLinkContainer key={action.name} to={action.href}>
          <NavItem>
            <span className={action.icon} /> {action.text}
            <span
              className='MemberActionsNavBar-ViewingCount badge badge-pill'
              title={`ist gerade in ${action.viewing} Tabs geöffnet`}
            >
              {action.viewing}
            </span>
          </NavItem>
        </IndexLinkContainer>
      )
    }
  }
}
