import React, { PropTypes, Component } from 'react'
import TeamStatisticChartContainer from '../../StatisticChartContainer/containers/TeamStatisticChartContainer'

export default class TeamStatisticCharts extends Component {
  componentDidMount() {
    if (!this.props.dataLoaded) {
      this.props.loadData()
    }
  }

  render() {
    return (
      <div>
        {this.existingChartsOrLoading(this.props.statisticCharts, this.props.dataLoaded)}
      </div>
    )
  }

  existingChartsOrLoading(charts, loaded) {
    if (!loaded) {
      return (
        <div>Loading... </div>
      )
    } else {
      return (
        charts.map(chart => {
          return(
            <div key={chart.id} className="chart">
              <h4>{chart.title}</h4>
              <TeamStatisticChartContainer statisticChart={chart} />
              <hr />
            </div>
          )
        })
      )
    }
  }
}
