import React, { PropTypes } from 'react'
import OverviewPanel from '../containers/OverviewPanel'
import PersonalStatisticCharts from '../containers/PersonalStatisticCharts'
import TeamStatisticCharts from '../containers/TeamStatisticCharts'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'
import ActualWaList from './ActualWaList'

export default class Dashboard extends React.Component {
  static propTypes = {
    hasOutstandingTimeAllocations: PropTypes.bool.isRequired,
    outstandingTimeAllocations: PropTypes.array.isRequired,
  }

  render() {
    const {
      user, hasOutstandingTimeAllocations, outstandingTimeAllocations,
    } = this.props

    const actualWa = hasOutstandingTimeAllocations ? (
      <ActualWaList outstandingTimeAllocations={outstandingTimeAllocations} />
    ) : null

    return (
      <div className='Dashboard'>
        <h1>Dashboard</h1>
        <hr />
        {actualWa}
        <CollapsiblePanel
          title={`Willkommen, ${user.name}`} identifier='dashboard'
          visible={true}
        >
          <OverviewPanel />
        </CollapsiblePanel>
        <CollapsiblePanel
          title='Meine W&A Statistiken' identifier='personal-statistic-charts'
          visible={false}
        >
          <PersonalStatisticCharts />
        </CollapsiblePanel>
        <CollapsiblePanel
          title='Team W&A Statistiken' identifier='team-statistic-charts'
          visible={false}
        >
          <TeamStatisticCharts />
        </CollapsiblePanel>
      </div>
    )
  }
}
