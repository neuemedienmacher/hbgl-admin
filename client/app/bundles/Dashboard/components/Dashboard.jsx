import React, { PropTypes } from 'react'
import OverviewPanel from '../containers/OverviewPanel'
import ActualWaList from './ActualWaList'

export default class Dashboard extends React.Component {
  static propTypes = {
    hasOutstandingTimeAllocations: PropTypes.bool.isRequired,
    outstandingTimeAllocations: PropTypes.array.isRequired,
  }

  render() {
    const {
      hasOutstandingTimeAllocations, outstandingTimeAllocations,
    } = this.props

    const actualWa = hasOutstandingTimeAllocations ? (
      <ActualWaList outstandingTimeAllocations={outstandingTimeAllocations} />
    ) : null

    return (
      <div className='Dashboard'>
        <h1>Dashboard</h1>
        <hr />
        {actualWa}
        <OverviewPanel />
      </div>
    )
  }
}
