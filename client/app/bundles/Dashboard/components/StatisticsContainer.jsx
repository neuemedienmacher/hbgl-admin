import React, { PropTypes, Component } from 'react'
import PersonalStatisticCharts from '../containers/PersonalStatisticCharts'
import TeamStatisticCharts from '../containers/TeamStatisticCharts'
import ControlledTabView from '../../ControlledTabView/containers/ControlledTabView'

export default class StatisticsContainer extends Component {
  componentDidMount() {
    if (!this.props.dataLoaded) {
      this.props.loadData()
    }
  }

  render() {
    return (
      <div>
        {this.existingChartsOrLoading(this.props.dataLoaded)}
      </div>
    )
  }

  existingChartsOrLoading(loaded) {
    if (!loaded) {
      return (
        <div>Loading chart data... </div>
      )
    } else {
      return (
        <ControlledTabView identifier="statistics">
          <PersonalStatisticCharts tabTitle='Individualstatistiken' />
          <TeamStatisticCharts tabTitle='Teamstatistiken' />
        </ControlledTabView>
      )
    }
  }
}
