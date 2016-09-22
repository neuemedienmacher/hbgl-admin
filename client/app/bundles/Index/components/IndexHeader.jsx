import React, { PropTypes, Component } from 'react'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import { LinkContainer } from 'react-router-bootstrap'
import IndexHeaderFilter from '../containers/IndexHeaderFilter'

export default class IndexHeader extends Component {
  render() {
    const {
      onQueryChange, query, onPlusClick, filters, model, params,
      plusButtonDisabled, routes
    } = this.props

    return (
      <Navbar inverse fluid>
        <Nav>
          {routes.map(route => {
            return(
              <LinkContainer key={route.id} to={route}>
                <NavItem>{route.anchor}</NavItem>
              </LinkContainer>
            )
          })}
        </Nav>
        <Navbar.Form pullRight inline>
          <div className='input-group'>
            <input
              className='form-control' name='query' type='search'
              placeholder='Search…'
              onChange={onQueryChange}
              value={query}
            />
            <span className='input-group-btn'>
              <button
                className='btn' onClick={onPlusClick}
                disabled={plusButtonDisabled}
              >
                <span className='fui-plus' />
              </button>
            </span>
          </div>
          {filters.map(filter => {
            return(
              <IndexHeaderFilter
                model={model} params={params} key={filter[0]} filter={filter}
              />
            )
          })}
        </Navbar.Form>
      </Navbar>
    )
  }
}
