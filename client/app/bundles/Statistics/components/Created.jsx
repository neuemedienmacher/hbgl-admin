import React, { PropTypes } from 'react'
import BarChart from '../containers/StatisticBarChart'

export default class Created extends React.Component {
  static propTypes = {}

  render() {
    return (
      <div className='jumbotron barchart'>
        <h2>Erstellte Angebote</h2>
        <BarChart />
      </div>
    )
  }
}
