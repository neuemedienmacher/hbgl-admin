import React, { PropTypes, Component } from 'react'
import BurnUpChartContainer from '../../ShowStatisticChart/containers/BurnUpChartContainer'
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
                <BurnUpChartContainer statisticChart={chart} />
                <hr />
              </div>
            )
          })
        }
      />
    )
  }
}
