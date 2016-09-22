import React, { PropTypes } from 'react'
import { Link } from 'react-router'

export default class Navigation extends React.Component {
  constructor(props, context) {
    super(props, context)
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
        <Link to='/statistics/offer_approved' className='list-group-item'>
          Angebote Approved
        </Link>
        <Link to='/statistics/organization_created' className='list-group-item'>
          Organisationen Erstellt
        </Link>
        <Link to='/statistics/organization_approved' className='list-group-item'>
          Organisationen Approved
        </Link>
        <Link to='/statistics/productivity_goals' className='list-group-item'>
          Produktivitätsziele
        </Link>
      </div>
    )
  }
}
