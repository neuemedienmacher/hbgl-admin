import React, { PropTypes } from 'react'
import { Link } from 'react-router'

export default class Navigation extends React.Component {
  constructor(props, context) {
    console.log(props, context)
    super(props, context)
    console.log(props, context)
  }
  static propTypes = {}

  render() {
    return (
			<div className='list-group'>
        <Link to='/statistics' className='list-group-item'>
					Übersicht
        </Link>
        <Link to='/statistics/offer_created' className='list-group-item'>
          Angebote Erstellt
        </Link>
        <Link to='/statistics/offer_created' className='list-group-item'>
          Angebote Approved
        </Link>
        <Link to='/statistics/offer_created' className='list-group-item'>
          Organisationen Erstellt
        </Link>
        <Link to='/statistics/offer_created' className='list-group-item'>
          Organisationen Approved
        </Link>
      </div>
    )
  }
}
