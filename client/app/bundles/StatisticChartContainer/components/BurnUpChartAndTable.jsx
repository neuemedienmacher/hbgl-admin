import React, { PropTypes } from 'react'
import BurnUpChart from '../containers/BurnUpChart'
import GoalsStatisticTable from '../containers/GoalsStatisticTable'

export default class BurnUpChartAndTable extends React.Component {
  render() {
    const { data, currentPoints, currentGoalProgress, lastGoalAmount } = this.props

    return (
      <div className="chart PersonalChartAndTable">
        <BurnUpChart data={data} chartId={this.props.chartId} />
        <h6>Jahresziel: {lastGoalAmount} / Bisher
          erreicht: {currentPoints} ( {currentGoalProgress}&#037; ) </h6>
        <p></p>
        <GoalsStatisticTable actualData={data.actual}
                             lastGoalAmount = {lastGoalAmount} />
      </div>
    )
  }
}
