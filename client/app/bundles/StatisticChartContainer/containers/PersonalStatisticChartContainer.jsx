import { connect } from 'react-redux'
import moment from 'moment'
import valuesIn from 'lodash/valuesIn'
import { getTimePointsBetween } from '../../../lib/timeUtils'
import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import BurnUpChartAndTable from '../components/BurnUpChartAndTable'

const mapStateToProps = (state, ownProps) => {
  const chart = ownProps.statisticChart
  const relevantTransitions =
    collectRelevantData(state.entities, 'statistic_transitions', chart)
  const relevantGoals =
    collectRelevantData(state.entities, 'statistic_goals', chart)
  const relevantStatistics =
    collectRelevantData(state.entities, 'statistics', chart, relevantTransitions)

  const sortedGoals = relevantGoals.sort(
    (a, b) => +(a.starts_at > b.starts_at) || +(a.starts_at === b.starts_at) - 1
  )
  const lastGoal = sortedGoals[sortedGoals.length - 1]

  const actualData = aggregateActualPoints(relevantStatistics, chart)
  const scopeData = aggregateScopePoints(sortedGoals, chart)
  const currentPoints = actualData ? actualData[actualData.length - 1].y : 0
  const currentGoalProgress = Math.round(currentPoints / lastGoal.amount * 100)

  const data = {
    actual: actualData,
    scope: scopeData,
    ideal: [{
      x: chart.starts_at, y: 0,
    }, {
      x: chart.ends_at, y: lastGoal.amount,
    }],
    //
    // projection: aggregateProjectionPoints(
    //   chart, lastActualPoint, allTimeAllocations, allUsers, allStatistics
    // ),
  }

  return {
    data,
    chartId: chart.id,
    lastGoalAmount: lastGoal.amount,
    currentPoints,
    currentGoalProgress
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

function aggregateActualPoints(statistics, chart) {
  const start = moment(chart.starts_at)
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

function aggregateScopePoints(goals, chart) {
  let points = []

  let previousGoal
  for (let goal of goals) {
    if (previousGoal) points.push({ x: goal.starts_at, y: previousGoal.amount })
    points.push({ x: goal.starts_at, y: goal.amount })
    previousGoal = goal
  }

  const lastPoint = points[points.length - 1]
  points.push({ x: chart.ends_at, y: lastPoint.y })

  return points
}

function collectRelevantData(entities, type, ...additionalArgs) {
  const allEntities = valuesIn(entities[type])
  if (!allEntities) return []
  let filter
  switch(type) {
    case 'statistics': filter = filterStatistics; break;
    case 'statistic_transitions': filter = filterStatisticTransitions; break;
    case 'statistic_goals': filter = filterStatisticGoals; break;
  }

  return allEntities.filter(filter(...additionalArgs))
}

function filterStatistics(chart, transitions) {
  return function(stat) {
    const matchingTransitions = transitions.filter(transition => {
      return stat.model == transition.klass_name &&
        stat.field_name == transition.field_name &&
        stat.field_start_value == transition.start_value &&
        stat.field_end_value == transition.end_value
    })
    return(
      stat.time_frame == 'daily' && stat.trackable_type == 'User' &&
        stat.trackable_id == chart.user_id && matchingTransitions.length
    )
  }
}

function filterStatisticTransitions(chart) {
  return function(transition) {
    return chart.statistic_transition_ids.includes(transition.id)
  }
}

function filterStatisticGoals(chart) {
  return function(goal) {
    return chart.statistic_goal_ids.includes(goal.id)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChartAndTable)
