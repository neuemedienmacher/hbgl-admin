import React, { PropTypes, Component } from 'react'
import { Navbar, Nav, NavItem, NavDropdown, MenuItem } from 'react-bootstrap'
import { IndexLinkContainer, LinkContainer } from 'react-router-bootstrap'
import Mascot from './Mascot'

export default class TopNav extends Component {
  render() {
    const {
      onSelect, activeKey, routes
    } = this.props

    return (
      <Navbar className="top-bar" staticTop>
        <Mascot />
        <Nav bsStyle='tabs' justified onSelect={onSelect} activeKey={activeKey}>
          <IndexLinkContainer to={{ pathname: '/' }}>
            <NavItem eventKey='2'>Dashboard</NavItem>
          </IndexLinkContainer>
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
          <li>
            <a href='/statistics'>
              Statistiken
            </a>
          </li>
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
          {/*
            // use this after removal of old Backend
            <IndexLinkContainer to={{ pathname:'/admin'}}>
              <NavItem>
                Altes Backend
              </NavItem>
            </IndexLinkContainer>
            <IndexLinkContainer to={{ pathname:'/users/sign_out'}} data-method='delete'>
              <NavItem>
                <span className='label label-important'>Abmelden</span>
              </NavItem>
            </IndexLinkContainer>
          */}
        </Nav>
      </Navbar>
    )
  }
}
