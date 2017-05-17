import React, { PropTypes } from 'react'
import BurnUpChartContainer from '../containers/BurnUpChartContainer'

export default class ShowStatisticChart extends React.Component {
  render() {
    return (
      <div className="content ShowStatisticChart">
        <h2>Ziel: {this.props.statistic_chart.title}</h2>
        <div className="chart">
          <BurnUpChartContainer
            statisticChart={this.props.statistic_chart}
          />
        </div>
      </div>
    )
  }
}
