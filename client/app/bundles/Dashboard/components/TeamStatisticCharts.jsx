import React, { PropTypes, Component } from 'react'
import TeamStatisticChartContainer from '../../StatisticChartContainer/containers/TeamStatisticChartContainer'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'

export default class TeamStatisticCharts extends Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      statisticCharts
    } = this.props

    return (
      <CollapsiblePanel
        title='Team W&A Statistiken' identifier='team-statistic-charts'
        visible={false}
        content={
          statisticCharts.map(chart => {
            return(
              <div key={chart.id} className="chart">
                <h4>{chart.title}</h4>
                <TeamStatisticChartContainer statisticChart={chart} />
              </div>
            )
          })
        }
      />
    )
  }
}
