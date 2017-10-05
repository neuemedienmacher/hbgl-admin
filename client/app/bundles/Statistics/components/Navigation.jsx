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
        <Link to='/statistics' className='list-group-item'> Übersicht </Link>
        <Link to='/statistics/offer-overview' className='list-group-item '>
          Angebotsübersicht
        </Link>
        <Link to='/statistics/organization-overview'
          className='list-group-item'
        >
          Orga-Übersicht (HQ)
        </Link>
        <Link to='/statistics/orga-offer-cities-overview'
          className='list-group-item'
        >
          Orga-Übersicht (Angebotsstädte)
        </Link>
        <Link to='/statistics/ratio-overview' className='list-group-item'>
          Angebote pro Orgas
        </Link>
        <Link to='/statistics/screening-overview' className='list-group-item'>
          Screening Orgas
        </Link>
        <Link to='/statistics/topic-overview' className='list-group-item'>
          Orga Topics
        </Link>
        {/*
        <Link to='/statistics/offer-created' className='list-group-item'>
          Angebote Erstellt
        </Link>
        <Link to='/statistics/offer-approved' className='list-group-item'>
          Angebote Approved
        </Link>
        <Link to='/statistics/organization-created' className='list-group-item'>
          Organisationen Erstellt
        </Link>
        <Link to='/statistics/organization-approved' className='list-group-item'>
          Organisationen Approved
        </Link>
        <Link to='/statistics/statistic-charts' className='list-group-item'>
          Produktivitätsziele
        </Link>
        */}
      </div>
    )
  }
}
