import React, { PropTypes, Component } from 'react'
import { Navbar, Nav, NavItem, NavDropdown, MenuItem } from 'react-bootstrap'
import { IndexLinkContainer, LinkContainer } from 'react-router-bootstrap'

export default class TopNav extends Component {
  render() {
    const {
      onSelect, activeKey, routes
    } = this.props

    return (
      <Navbar className="top-bar" staticTop>
        <svg className="top-bar__mascot" xmlns="http://www.w3.org/2000/svg" width="49" height="68" viewBox="0 0 49 68">
          <g fill="none" fillRule="evenodd">
            <path fill="#D6A974" fillRule="nonzero" d="M24.6548534,57.1247719 L28.7704321,57.1247719 L28.7704321,67.5323509 L24.6548534,67.5323509 L24.6548534,57.1247719 L24.6548534,57.1247719 Z M19.6599537,57.1247719 L23.77375,57.1247719 L23.77375,67.5323509 L19.6599537,67.5323509 L19.6599537,57.1247719 L19.6599537,57.1247719 Z"/>
            <ellipse cx="24.215" cy="18.931" fill="#D6A974" fillRule="nonzero" rx="18.309" ry="18.382"/>
            <path fill="#291F00" fillRule="nonzero" d="M20.2808256,8.70757895 L18.9891744,13.3482807 C15.1094676,12.9235789 11.3687886,12.0342105 7.82417438,10.7314737 C10.8275309,4.69617544 17.0380324,0.549368421 24.2151929,0.549368421 C31.3923534,0.549368421 37.6040432,4.69617544 40.6062114,10.7314737 C35.494267,12.6086316 29.9741512,13.6334035 24.2151929,13.6334035 C22.8902701,13.6334035 21.5784182,13.5773333 20.2820139,13.4705614 L20.2820139,8.70817544 L20.2808256,8.70757895 L20.2808256,8.70757895 Z"/>
            <g fill="#C08B76" fillRule="nonzero" transform="translate(11.289 19.684)">
              <ellipse cx="3.232" cy="3.63" rx="3.113" ry="3.126"/>
              <ellipse cx="22.629" cy="3.63" rx="3.113" ry="3.126"/>
            </g>
            <g fill="#40301A" fillRule="nonzero" transform="translate(18.418 19.684)">
              <ellipse cx=".966" cy="1.136" rx="1" ry="1"/>
              <ellipse cx="10.636" cy="1.135" rx="1" ry="1"/>
            </g>
            <path stroke="#40301A" strokeWidth=".424" d="M21.630108,22.9154035 C22.194537,23.3687368 23.0643519,23.6669825 23.9727855,23.7117193 L24.4629475,23.7117193 C25.3719753,23.6675789 26.2453549,23.3687368 26.8080015,22.9154035"/>
            <path stroke="#40301A" strokeWidth=".371" d="M20.6242361,19.445614 C19.9386034,18.7584561 18.8287577,18.7596491 18.1437191,19.449193 M30.2961728,19.445614 C29.609946,18.7584561 28.498912,18.7596491 27.8138735,19.449193"/>
            <path fill="#417505" fillRule="nonzero" d="M18.1229244,44.2101404 C18.1229244,42.5876842 18.764591,41.0332281 19.9071142,39.8855789 C21.0490432,38.7403158 22.5985494,38.0961053 24.2145988,38.0961053 C25.8306481,38.0961053 27.378966,38.7403158 28.5220833,39.8855789 C29.6652006,41.0332281 30.305679,42.5876842 30.305679,44.2101404 L30.305679,61.8125965 L18.1229244,61.8125965 L18.1229244,44.2101404 Z"/>
            <g transform="translate(0 11.333)">
              <polyline fill="#40301A" fillRule="nonzero" points="44.404 40.196 23.893 47.72 23.893 14.699 44.404 7.175"/>
              <polyline fill="#D8D5C1" fillRule="nonzero" points="23.893 47.72 3.381 40.196 3.381 7.175 23.893 14.699"/>
              <ellipse cx="3.379" cy="21.781" fill="#D6A974" fillRule="nonzero" rx="3.02" ry="3.032"/>
              <ellipse cx="44.405" cy="21.781" fill="#D6A974" fillRule="nonzero" rx="3.02" ry="3.032"/>
              <g transform="translate(34.46)">
                <path fill="#F7A100" fillRule="nonzero" d="M7.69108796,0.192666667 C3.57075617,0.192666667 0.230524691,3.54494737 0.230524691,7.68221053 L7.69108796,7.68221053 L7.69108796,0.192070175 L7.69108796,0.192666667 L7.69108796,0.192666667 Z"/>
                <path fill="#006B81" fillRule="nonzero" d="M7.65425154,0.192666667 L7.65425154,6.1814386 L1.68912809,6.1814386 C1.68912809,9.48778947 4.35976852,12.1690175 7.65425154,12.1690175 C10.9487346,12.1690175 13.619375,9.48838596 13.619375,6.1814386 C13.619375,2.87389474 10.9487346,0.192666667 7.65425154,0.192666667 L7.65425154,0.192666667 L7.65425154,0.192666667 Z"/>
                <path stroke="#D8D5C1" strokeWidth=".177" d="M8.40108025,2.69375439 C8.40583333,2.03403509 8.94412037,1.50315789 9.60123457,1.50852632 C10.259537,1.51270175 10.7877238,2.05252632 10.7835648,2.7134386"/>
                <ellipse cx="9.605" cy="2.777" fill="#D8D5C1" fillRule="nonzero" rx="1" ry="1"/>
              </g>
            </g>
          </g>
        </svg>
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
