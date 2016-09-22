import React, { PropTypes, Component } from 'react'
import { Navbar, Nav, NavItem, NavDropdown, MenuItem } from 'react-bootstrap'
import { IndexLinkContainer, LinkContainer } from 'react-router-bootstrap'

export default class TopNav extends Component {
  render() {
    const {
      onSelect, activeKey, routes
    } = this.props

    return (
      <Navbar staticTop>
        <Nav bsStyle='tabs' justified onSelect={onSelect} activeKey={activeKey}>
          <NavDropdown title='Administration' eventKey='1' id='actionDropdown'>
            {routes.map(route => {
              return (
                <LinkContainer key={route.id} to={route}>
                  <MenuItem eventKey={`1.${route.id}`}>
                    {route.anchor}
                  </MenuItem>
                </LinkContainer>
              )
            })}
          </NavDropdown>
          <IndexLinkContainer to={{ pathname: '/' }}>
            <NavItem eventKey='2'>Dashboard</NavItem>
          </IndexLinkContainer>
          <li>
            <a href='/admin'>
              Altes Backend
            </a>
          </li>
          <li>
            <a href='/users/sign_out' data-method='delete'>
              <span className='label label-important'>Abmelden</span>
            </a>
          </li>
        </Nav>
      </Navbar>
    )
  }
}
