import { connect } from 'react-redux'
import moment from 'moment'
import uniq from 'lodash/array/uniq'
import compact from 'lodash/array/compact'
import cloneDeep from 'lodash/lang/cloneDeep'

import ChartPerUserAndDate from '../components/ChartPerUserAndDate'
import updateDateRange from '../actions/updateDateRange'

const mapStateToProps = function(state, ownProps) {
  const startDate = state.statisticSettings.startDate
  const endDate = state.statisticSettings.endDate
  const selectedUsers = state.statisticSettings.selectedUsers

  const filteredData = cloneDeep(state.statistics.filter(function(statistic) {
    const x = moment(statistic.x, 'YYYY-MM-DD')

    return (
      statistic.topic === ownProps.topic &&
        x.isBefore(endDate) &&
        x.isAfter(startDate) &&
        selectedUsers.includes(statistic.user_id)
    )
  }))

  const allUserIdsForWhichThereIsData = compact(uniq(state.statistics.map(
    (statistic) => statistic.user_id
  )))
  const filteredUsers = state.users.filter((user) => {
    return allUserIdsForWhichThereIsData.includes(user.id)
  })

  return {
    // Chart Rendering
    data: filteredData,
    startDate,
    endDate,

    // Date Range Selection
    dateRangeStartDate: moment('01/01/2015'),
    dateRangeEndDate: now => now,
    dateRangeMinDate: moment('01/01/2015'),
    dateRangeMaxDate: now => now,
    dateRangeRanges: {
      'Seit Anbeginn': {
        startDate: function(now) { return moment('01/01/2015') },
        endDate: function(now) { return now },
      },
      'Heute': {
        startDate: function(now) { return now },
        endDate: function(now) { return now },
      },
      'Diese Woche': {
        startDate: function(now) { return now.weekday(0) },
        endDate: function(now) { return now },
      },
      'Dieser Monat': {
        startDate: function(now) { return now.date(1) },
        endDate: function(now) { return now },
      },
      'Dieses Jahr': {
        startDate: function(now) { return now.dayOfYear(1) },
        endDate: function(now) { return now },
      },
    },

    // User Selection
    users: filteredUsers,
    selectedUsers,
	}
}

const mapDispatchToProps = function(dispatch, ownProps) {
  const handleChange = range => (
    dispatch(updateDateRange(range))
  )
  return {
    dateRangeInit: handleChange,
    dateRangeChange: handleChange,
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ChartPerUserAndDate)
