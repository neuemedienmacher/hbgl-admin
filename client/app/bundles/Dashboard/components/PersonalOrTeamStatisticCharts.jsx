import React, { PropTypes, Component } from 'react'
import PersonalStatisticChartContainer from '../../StatisticChartContainer/containers/PersonalStatisticChartContainer'
import TeamStatisticChartContainer from '../../StatisticChartContainer/containers/TeamStatisticChartContainer'
import ControlledSelectView from '../../ControlledSelectView/containers/ControlledSelectView'

export default class PersonalOrTeamStatisticCharts extends Component {
  componentDidMount() {
    if (!this.props.dataLoaded) {
      this.props.loadData()
    }
  }
  componentWillReceiveProps(nextProps) {
    if(nextProps.trackableId != this.props.trackableId ||
       nextProps.dataLoaded && nextProps.dataLoaded.meta != undefined &&
       nextProps.dataLoaded.meta.current_page < nextProps.dataLoaded.meta.total_pages
    ) {
      this.props.loadData(nextProps)
    }
  }

  render() {
    return (
      <div className="select-set">
        <span className="select-set__label">Zeige Statistiken von:</span>
        <ControlledSelectView identifier={this.props.chartType + 'Statistics'}>
          {this.props.selectable_data}
        </ControlledSelectView>
        {this.existingChartsOrLoading(
          this.props.statisticCharts, this.props.dataLoaded, this.props.chartType
        )}
      </div>
    )
  }

  existingChartsOrLoading(charts, loaded, type) {
    if (!loaded) {
      return (
        <div>Loading statistic data: {this.props.dataPercentage}</div>
      )
    } else {
      return (
        charts.map(chart => {
          return(
            <div key={chart.id} className="chart">
              <h4>{chart.title}</h4>
              {this.renderUserOrTeamChart(type, chart)}
              <hr />
            </div>
          )
        })
      )
    }
  }

  renderUserOrTeamChart(type, chart) {
    if (type == 'User') {
      return <PersonalStatisticChartContainer statisticChart={chart} />
    } else {
      return <TeamStatisticChartContainer statisticChart={chart} />
    }
  }
}
