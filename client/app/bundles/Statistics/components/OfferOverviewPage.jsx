import React from 'react'
import OverviewTable from '../containers/OverviewTable'

export default class OfferOverviewPage extends React.Component {
  render() {
    return (
      <div className='jumbotron overview'>
        <h2>Angebotsübersicht</h2>
        <OverviewTable model='offer' />
      </div>
    )
  }
}
