import React, { PropTypes, Component } from 'react'
import { FormControl } from 'react-bootstrap'
import PersonalStatisticChartContainer from '../../StatisticChartContainer/containers/PersonalStatisticChartContainer'
import TeamStatisticChartContainer from '../../StatisticChartContainer/containers/TeamStatisticChartContainer'

export default class PersonalOrTeamStatisticCharts extends Component {
  componentDidMount() {
    if (!this.props.dataLoaded) {
      this.props.loadData()
    }
  }
  componentWillReceiveProps(nextProps) {
    if(!nextProps.dataLoaded && nextProps.trackableId != this.props.trackableId) {
      this.props.loadData(nextProps)
    }
  }

  render() {
    return (
      <div>
        Zeige Statistiken von:
        <FormControl componentClass="select" onChange={this.props.onSelect}>
          {this.props.selectable_data.map( data => {
            return(<option value={data[0]}>{data[1]}</option>)
          })}
        </FormControl>
        {this.existingChartsOrLoading(
          this.props.statisticCharts, this.props.dataLoaded, this.props.chartType
        )}
      </div>
    )
  }

  existingChartsOrLoading(charts, loaded, type) {
    if (!loaded) {
      return (
        <div>Loading statistic data... </div>
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
