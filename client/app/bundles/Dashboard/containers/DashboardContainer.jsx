import { connect } from 'react-redux'
import moment from 'moment'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import valuesIn from 'lodash/valuesIn'
import { getTimePointsBetween } from '../../../lib/timeUtils'
import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import Dashboard from '../components/Dashboard'

const mapStateToProps = (state, ownProps) => {
  const outstandingTimeAllocations = getOutstandingTimeAllocations(
    valuesIn(state.entities.time_allocations), state.entities.current_user
  )

  return {
    hasOutstandingTimeAllocations: !!outstandingTimeAllocations.length,
    outstandingTimeAllocations,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

function getOutstandingTimeAllocations(time_allocations, current_user) {
  let outstandingTimeAllocations = []

  // Displaying outstanding allocations for the last 5 weeks
  const firstPotentialWeek = moment().subtract(5, 'weeks')
  const lastPotentialWeek = moment().subtract(1, 'weeks')
  const weeks =
    getTimePointsBetween(firstPotentialWeek, lastPotentialWeek, 'week')

  for (let week of weeks) {
    let week_number = week.week()
    let [_isFromThatWeek, isHistorical, weeksTimeAllocation] =
      getAllocationForWeekAndUser(
        time_allocations, week_number, week.year(), current_user.id
      )

    if (isHistorical) {
      weeksTimeAllocation = merge(clone(weeksTimeAllocation), {
        week_number,
        id: null
      })
    }

    if (!weeksTimeAllocation.actual_wa_hours &&
        weeksTimeAllocation.desired_wa_hours > 0) {
      outstandingTimeAllocations.push(weeksTimeAllocation)
    }
  }

  return outstandingTimeAllocations
}

export default connect(mapStateToProps, mapDispatchToProps)(Dashboard)
