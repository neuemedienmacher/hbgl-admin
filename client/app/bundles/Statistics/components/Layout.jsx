import React, { PropTypes } from 'react'
import Navigation from './Navigation'

export default class Layout extends React.Component {
  static propTypes = {
    hasUsers: PropTypes.bool.isRequired,
    hasStatistics: PropTypes.bool.isRequired,
    getStatistics: PropTypes.func.isRequired,
    getUsers: PropTypes.func.isRequired,
  }

  componentWillMount() {
    if (!this.props.hasStatistics) { this.props.getStatistics() }
    if (!this.props.hasUsers) { this.props.getUsers() }
  }

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
