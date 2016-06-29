import React, { PropTypes } from 'react'
import Navigation from './Navigation'

export default class Layout extends React.Component {
  render() {
    return (
			<div className='container-fluid'>
        <div className='col-xs-9'>
          {this.props.children}
        </div>
        <div className='col-xs-3'>
          <Navigation />
        </div>
      </div>
    )
  }
}
