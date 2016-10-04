import { connect } from 'react-redux'
import moment from 'moment'
import clone from 'lodash/clone'
import valuesIn from 'lodash/valuesIn'
import { getTimePointsBetween } from '../../../lib/timeUtils'
import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import BurnUpChart from '../../Statistics/components/BurnUpChart'

const mapStateToProps = (state, ownProps) => {
  const goal = ownProps.productivity_goal
  const allStatistics = valuesIn(state.entities.statistics)
  const allUsers = valuesIn(state.entities.users)
  const allTimeAllocations = valuesIn(state.entities.time_allocations)
  const relevantStatistics = allStatistics.filter(stat => {
    return (
      stat.model == goal.target_model &&
        stat.field_name == goal.target_field_name &&
        stat.field_end_value == goal.target_field_value &&
        stat.time_frame == 'daily' &&
        stat.user_team_id == goal.user_team_id
    )
  })

  const actualData = aggregateActualPoints(relevantStatistics, goal)
  const lastActualPoint = clone(actualData[actualData.length - 1])

  const data = {
    actual: actualData,

    ideal: [{
      x: goal.starts_at, y: 0,
    }, {
      x: goal.ends_at, y: goal.target_count,
    }],

    projection: aggregateProjectionPoints(
      goal, lastActualPoint, allTimeAllocations, allUsers, allStatistics
    ),

    scope: [{
      x: goal.starts_at, y: goal.target_count,
    }, {
      x: moment().format('YYYY-MM-DD'), y: goal.target_count,
    }],
  }

  return {
    data,
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

function aggregateActualPoints(statistics, goal) {
  const start = moment(goal.starts_at)
  const end = moment()
  let points = []
  let runningTotal = 0

  for (let day of getTimePointsBetween(start, end)) {
    const statisticsForCurrentDay = statistics.filter((statistic) =>
      day.isSame(statistic.date)
    )

    for (let statistic of statisticsForCurrentDay) {
      runningTotal += statistic.count
    }

    points.push({ x: day.format('YYYY-MM-DD'), y: runningTotal })
  }

  return points
}

function aggregateProjectionPoints(
  goal, lastActualPoint, time_allocations, users, statistics
) {
  const usersCurrentlyInTeam = users.filter(user =>
    user.user_team_ids.includes(goal.user_team_id)
  )
  const expectedHourlyGoalReachCount = usersCurrentlyInTeam.map(user =>
    averageWeeklyGoalsReachedForUser(user.id, statistics)
  ).reduce((pv, cv) => { return pv + cv }, 0)

  let projectionData = [lastActualPoint]
  let lastCount = lastActualPoint.y
  let week = moment().startOf('week')
  let goalReachedInProjection = false
  let iterationCounter = 0

  while (!goalReachedInProjection) {
    // prepare point from given data
    let endOfWeek = week.day(5).format('YYYY-MM-DD') // next Friday
    let hoursAvailableForTeamInWeek =
      availableHoursForUsersInWeek(week, usersCurrentlyInTeam, time_allocations)
    let expectedCountForWeek =
      expectedHourlyGoalReachCount * hoursAvailableForTeamInWeek
    let expectedEndOfWeekCount = lastCount + expectedCountForWeek

    // limit point to goal max
    if (expectedEndOfWeekCount >= goal.target_count) {
      expectedEndOfWeekCount = goal.target_count
      goalReachedInProjection = true
    }

    // commit point
    projectionData.push({
      x: endOfWeek, y: expectedEndOfWeekCount
    })

    // continue or abort iteration
    lastCount = expectedEndOfWeekCount
    week.add(1, 'week')
    if (iterationCounter >= 20) {
      break // Endless recursion protection
    } else {
      iterationCounter += 1
    }
  }

  return projectionData
}

function averageWeeklyGoalsReachedForUser(user_id, statistics) {
  const pastWeeklyUserStatistics = statistics.filter((statistic) =>
    statistic.user_id == user_id && statistic.time_frame == 'weekly'
  )

  const allHourlyGoalsReached = pastWeeklyUserStatistics.reduce((cv, pv) => {
    return cv + pv.count
  }, 0)

  return allHourlyGoalsReached / pastWeeklyUserStatistics.length
}

function availableHoursForUsersInWeek(
  week, usersCurrentlyInTeam, time_allocations
) {
  return usersCurrentlyInTeam.map(user => {
    const [_e, _h, allocation] = getAllocationForWeekAndUser(
      time_allocations, week.week(), week.year(), user.id
    )
    return allocation.desired_wa_hours
  }).reduce((cv, pv) => { return cv + pv }, 0)
}

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChart)
