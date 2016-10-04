import { connect } from 'react-redux'
import moment from 'moment'
import uniq from 'lodash/uniq'
import compact from 'lodash/compact'
import cloneDeep from 'lodash/cloneDeep'
import valuesIn from 'lodash/valuesIn'

import ChartPerUserAndDate from '../components/ChartPerUserAndDate'
import updateDateRange from '../actions/updateDateRange'

const mapStateToProps = (state, ownProps) => {
  const startDate = state.statistics.statisticSettings.startDate
  const endDate = state.statistics.statisticSettings.endDate
  const selectedUsers = state.statistics.statisticSettings.selectedUsers
  const allStatistics = valuesIn(state.entities.statistics)

  const filteredData = cloneDeep(allStatistics.filter(statistic => {
    const date = moment(statistic.date, 'YYYY-MM-DD')

    return (
      statistic.model === ownProps.model &&
        statistic.field_end_value === ownProps.field_end_value &&
        date.isBefore(endDate) &&
        date.isAfter(startDate) &&
        selectedUsers.includes(statistic.user_id)
    )
  }))

  const allUserIdsForWhichThereIsData = compact(uniq(allStatistics.map(
    (statistic) => statistic.user_id
  )))
  const filteredUsers = valuesIn(state.entities.users).filter(user =>
    allUserIdsForWhichThereIsData.includes(user.id)
  )

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
        startDate: now => moment('01/01/2015'),
        endDate: now => now,
      },
      'Heute': {
        startDate: now => now,
        endDate: now => now,
      },
      'Diese Woche': {
        startDate: now => now.weekday(0),
        endDate: now => now,
      },
      'Dieser Monat': {
        startDate: now => now.date(1),
        endDate: now => now,
      },
      'Dieses Jahr': {
        startDate: now => now.dayOfYear(1),
        endDate: now => now,
      },
    },

    // User Selection
    users: filteredUsers,
    selectedUsers,
	}
}

const mapDispatchToProps = (dispatch, ownProps) => {
  const handleChange = range => (
    dispatch(updateDateRange(range))
  )
  return {
    dateRangeInit: handleChange,
    dateRangeChange: handleChange,
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ChartPerUserAndDate)
