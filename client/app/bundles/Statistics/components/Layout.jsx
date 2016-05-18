import React, { PropTypes } from 'react'
import StatisticsNav from './StatisticsNav'

export default class Layout extends React.Component {
  static propTypes = {}

  render() {
    return (
			<div className='container-fluid'>
        <div className='col-xs-9'>
          {this.props.children}
        </div>
        <div className='col-xs-3'>
          <StatisticsNav />
        </div>
      </div>
    )
  }
}
