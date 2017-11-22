import React, { PropTypes, Component } from 'react'
import TopNav from '../containers/TopNav'
import FlashMessageList from '../containers/FlashMessageList'

export default class Layout extends Component {
  componentDidUpdate() {
    document.title = this.props.location.pathname.substr(1) || 'dashboard'
  }

  render() {
    return (
      <div className='Layout claradmin'>
        <TopNav />
        <div className='container'>
          <div className='container-fluid'>
            <div className='row'>
              <FlashMessageList />

              {this.props.children}
            </div>
          </div>
        </div>
      </div>
    )
  }
}
