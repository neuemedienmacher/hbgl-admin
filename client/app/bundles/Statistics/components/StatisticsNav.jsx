import React, { PropTypes } from 'react'
import { Link } from 'react-router'

export default class StatisticsNav extends React.Component {
  constructor(props, context) {
    console.log(props, context)
    super(props, context)
    console.log(props, context)
  }
  static propTypes = {}

  render() {
    return (
			<div className='list-group'>
        <Link to='/statistics/offer_created' className='list-group-item'>
          Erstellte Angebote
        </Link>
      </div>
    )
  }
}
