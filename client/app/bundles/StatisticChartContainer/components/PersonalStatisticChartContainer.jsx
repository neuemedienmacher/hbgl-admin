import React, { PropTypes } from 'react'
import BurnUpChart from '../containers/BurnUpChart'
import GoalsStatisticTable from '../containers/GoalsStatisticTable'

export default class PersonalStatisticChartContainer extends React.Component {
  render() {
    const { data } = this.props

    return (
      <div className="chart PersonalChartAndTable">
        <BurnUpChart data={data} chartId={this.props.chartId} />
        <h6>Jahresziel: {this.props.lastGoalAmount}</h6>
        <GoalsStatisticTable actualData={data.actual}
                             lastGoalAmount = {this.props.lastGoalAmount} />
      </div>
    )
  }
}
