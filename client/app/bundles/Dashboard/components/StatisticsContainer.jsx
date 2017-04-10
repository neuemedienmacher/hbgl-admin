import React, { PropTypes, Component } from 'react'
import { Tabs, Tab } from 'react-bootstrap'
import PersonalStatisticCharts from '../containers/PersonalStatisticCharts'
import TeamStatisticCharts from '../containers/TeamStatisticCharts'

export default class StatisticsContainer extends Component {
  componentDidMount() {
    if (!this.props.dataLoaded) {
      this.props.loadData()
    }
  }

  render() {
    return (
      <div>
        {this.existingChartsOrLoading(
          this.props.dataLoaded, this.props.handleSelect, this.props.selectedTab
        )}
      </div>
    )
  }

  existingChartsOrLoading(loaded, handleSelect, selected) {
    if (!loaded) {
      return (
        <div>Loading chart data... </div>
      )
    } else {
      return (
        <Tabs activeKey={selected} onSelect={handleSelect} id="controlled-tab">
          <Tab eventKey={0} title="Individualstatistiken">
            <PersonalStatisticCharts />
          </Tab>
          <Tab eventKey={1} title="Teamstatistiken">
            <TeamStatisticCharts />
          </Tab>
        </Tabs>
      )
    }
  }
}
