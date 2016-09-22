import React, { PropTypes } from 'react'
import { DateRange } from 'react-date-range'
import BarChart from './BarChart'
import UserSelectionContainer from '../containers/UserSelectionContainer'

export default class ChartPerUserAndDate extends React.Component {
  static propTypes = {}

  render() {
    const {
      title, topic, data, startDate, endDate,
    } = this.props

    return (
      <div className='jumbotron barchart'>
        <h2>{title}</h2>
        <BarChart
          topic={topic}
          data={data}
          startDate={startDate}
          endDate={endDate}
        />
        <DateRange
          firstDayOfWeek={ 1 }
          startDate={this.props.dateRangeStartDate}
          endDate={this.props.dateRangeEndDate}
          minDate={this.props.dateRangeMinDate}
          maxDate={this.props.dateRangeMaxDate}
          onInit={this.props.dateRangeInit}
          onChange={this.props.dateRangeChange}
          ranges={this.props.dateRangeRanges}
        />
        <UserSelectionContainer
          users={this.props.users}
          selectedUsers={this.props.selectedUsers}
        />
      </div>
    )
  }
}
