import React, { PropTypes, Component } from 'react'
import PersonalStatisticChartContainer from '../../StatisticChartContainer/containers/PersonalStatisticChartContainer'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'

export default class PersonalStatisticCharts extends Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      statisticCharts
    } = this.props

    return (
      <CollapsiblePanel
        title='Meine W&A Statistiken' identifier='personal-statistic-charts'
        visible={false}
        content={
          statisticCharts.map(chart => {
            return(
              <div key={chart.id} className="chart">
                <h4>{chart.title}</h4>
                <PersonalStatisticChartContainer statisticChart={chart} />
              </div>
            )
          })
        }
      />
    )
  }
}
