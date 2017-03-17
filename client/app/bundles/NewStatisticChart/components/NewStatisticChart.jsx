import React, { PropTypes } from 'react'
import StatisticChartForm from '../containers/StatisticChartForm'
import PreviewBurnUpChart from '../containers/PreviewBurnUpChart'

export default class NewStatisticChart extends React.Component {
  render() {
    return (
      <div className='content NewStatisticChart'>
        <h2>Neues Produktivitätsziel</h2>
        <div className='chart'>
          <PreviewBurnUpChart />
        </div>
        <StatisticChartForm />
      </div>
    )
  }
}
