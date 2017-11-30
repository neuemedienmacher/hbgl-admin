import React, { PropTypes } from 'react'
import OverviewPanel from '../components/OverviewPanel'
import StatisticsContainer from '../containers/StatisticsContainer'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'
import ActualWaList from './ActualWaList'

export default class Dashboard extends React.Component {
  static propTypes = {
    hasOutstandingTimeAllocations: PropTypes.bool.isRequired,
    outstandingTimeAllocations: PropTypes.array.isRequired,
  }

  componentWillReceiveProps(nextProps) {
    console.log('Dashboard componentWillReceiveProps', this.props.params)
    console.log('Dashboard componentWillReceiveProps', nextProps.params)
    // if (isEqual(nextProps.query, this.props.query) == false ||
    //     nextProps.model != this.props.model
    // ) {
    //   this.props.loadData(nextProps.query, nextProps.model)
    // }
  }

  render() {

    const {
      user, hasOutstandingTimeAllocations, outstandingTimeAllocations
    } = this.props
    const actualWa = hasOutstandingTimeAllocations ? (
      <ActualWaList outstandingTimeAllocations={outstandingTimeAllocations} />
    ) : null

    return (
      <div className='Dashboard'>
        <h1 className="page-title">Dashboard</h1>
        {actualWa}
        <CollapsiblePanel
          title={`Willkommen, ${user.name}`} identifier='dashboard'
          visible={true}
        >
          <OverviewPanel params={this.props.params}/>
        </CollapsiblePanel>
        <CollapsiblePanel
          title='W&A Statistiken' identifier='overall-statistic-charts'
          visible={false}
        >
          <StatisticsContainer />
        </CollapsiblePanel>
      </div>
    )
  }
}
