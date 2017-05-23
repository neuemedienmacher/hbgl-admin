import React, { PropTypes, Component } from 'react'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import { LinkContainer, IndexLinkContainer } from 'react-router-bootstrap'
import IndexHeaderFilter from '../containers/IndexHeaderFilter'

export default class IndexHeader extends Component {
  render() {
    const {
      onQueryChange, query, onPlusClick, filters, model, params, lockedParams,
      plusButtonDisabled, routes, uiKey
    } = this.props

    return (
      <Navbar fluid>
        <Nav>
          {routes.map(route => this.renderLinkContainer(route))}
        </Nav>
        <Navbar.Form pullRight>
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
                <span className='fa fa-plus' />
              </button>
            </span>
          </div>
          {filters.map(filter => {
            return(
              <IndexHeaderFilter
                model={model} params={params} key={filter[0]} filter={filter}
                uiKey={uiKey} lockedParams={lockedParams}
              />
            )
          })}
        </Navbar.Form>
      </Navbar>
    )
  }

  renderLinkContainer(route) {
    if (route.action == 'index') {
      return(
        <IndexLinkContainer key={route.id} to={route}>
          <NavItem>{route.anchor}</NavItem>
        </IndexLinkContainer>
      )
    }
    else {
      return(
        <LinkContainer key={route.id} to={route}>
          <NavItem>{route.anchor}</NavItem>
        </LinkContainer>
      )
    }
  }
}
