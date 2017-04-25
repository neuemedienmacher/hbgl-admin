import React, { PropTypes, Component } from 'react'
import TopNav from '../containers/TopNav'

export default class Layout extends Component {
  render() {
    return (
      <div className='Layout claradmin'>
        <TopNav />
        <div className='container'>
          <div className='container-fluid'>
            <div className='row'>
              {/*cell(:flash, collection: flash)*/}

              {this.props.children}
            </div>
          </div>
        </div>
      </div>
    )
  }
}
