import { connect } from 'react-redux'
import moment from 'moment'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import valuesIn from 'lodash/valuesIn'
import { getTimePointsBetween } from '../../../lib/timeUtils'
import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import Dashboard from '../components/Dashboard'

const mapStateToProps = (state, ownProps) => {
  // read current_user from users with current_user.id (current_user not updated)
  const user = state.entities.users[state.entities['current-user-id']]
  const outstandingTimeAllocations = getOutstandingTimeAllocations(
    valuesIn(state.entities['time-allocations']), user
  )

  return {
    user,
    hasOutstandingTimeAllocations: !!outstandingTimeAllocations.length,
    outstandingTimeAllocations,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

function getOutstandingTimeAllocations(timeAllocations, user) {
  let outstandingTimeAllocations = []
  return outstandingTimeAllocations // NOTE: this should not be rendered

  // Displaying outstanding allocations for the last 5 weeks
  const firstPotentialWeek = moment().subtract(5, 'weeks')
  const lastPotentialWeek = moment().subtract(1, 'weeks')
  const weeks =
    getTimePointsBetween(firstPotentialWeek, lastPotentialWeek, 'week')

  for (let week of weeks) {
    let weekNumber = week.week()
    let [_isFromThatWeek, isHistorical, weeksTimeAllocation] =
      getAllocationForWeekAndUser(
        timeAllocations, weekNumber, week.year(), user.id
      )

    if (isHistorical) {
      weeksTimeAllocation = merge(clone(weeksTimeAllocation), {
        weekNumber,
        id: null
      })
    }

    if (!weeksTimeAllocation['actual-wa-hours'] &&
        weeksTimeAllocation['desired-wa-hours'] > 0) {
      outstandingTimeAllocations.push(weeksTimeAllocation)
    }
  }

  return outstandingTimeAllocations
}

export default connect(mapStateToProps, mapDispatchToProps)(Dashboard)
