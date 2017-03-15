import React, { PropTypes, Component } from 'react'
import BurnUpChartContainer from '../../ShowStatisticChart/containers/BurnUpChartContainer'

export default class PersonalStatisticCharts extends Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      statisticCharts
    } = this.props

    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Meine W&A Statistiken</h3>
        </div>
        <div className="panel-body">
          {statisticCharts.map(chart => {
            return(
              <div key={chart.id} className="chart">
                <h4>{chart.title}</h4>
                <BurnUpChartContainer statisticChart={chart} />
                <hr />
              </div>
            )
          })}
        </div>
      </div>
    )
  }
}
