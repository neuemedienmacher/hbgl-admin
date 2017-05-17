import { connect } from 'react-redux'
import moment from 'moment'
import valuesIn from 'lodash/valuesIn'
import { getTimePointsBetween } from '../../../lib/timeUtils'
import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import BurnUpChartAndTable from '../components/BurnUpChartAndTable'

const mapStateToProps = (state, ownProps) => {
  const chart = ownProps.statisticChart
  const relevantTransitions =
    collectRelevantData(state.entities, 'statistic-transitions', chart)
  const relevantGoals =
    collectRelevantData(state.entities, 'statistic-goals', chart)
  const relevantStatistics =
    collectRelevantData(state.entities, 'statistics', chart, relevantTransitions)

  const sortedGoals = relevantGoals.sort(
    (a, b) => +(a['starts-at'] > b['starts-at']) || +(a['starts-at'] === b['starts-at']) - 1
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
      x: chart['starts-at'], y: 0,
    }, {
      x: chart['ends-at'], y: lastGoal.amount,
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
  const start = moment(chart['starts-at'])
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
    if (previousGoal) points.push({ x: goal['starts-at'], y: previousGoal.amount })
    points.push({ x: goal['starts-at'], y: goal.amount })
    previousGoal = goal
  }

  const lastPoint = points[points.length - 1]
  points.push({ x: chart['ends-at'], y: lastPoint.y })

  return points
}

function collectRelevantData(entities, type, ...additionalArgs) {
  const allEntities = valuesIn(entities[type])
  if (!allEntities) return []
  let filter
  switch(type) {
    case 'statistics': filter = filterStatistics; break;
    case 'statistic-transitions': filter = filterStatisticTransitions; break;
    case 'statistic-goals': filter = filterStatisticGoals; break;
  }

  return allEntities.filter(filter(...additionalArgs))
}

function filterStatistics(chart, transitions) {
  return function(stat) {
    const matchingTransitions = transitions.filter(transition => {
      return stat.model == transition['klass-name'] &&
        stat['field-name'] == transition['field-name'] &&
        stat['field-start-value'] == transition['start-value'] &&
        stat['field-end-value'] == transition['end-value']
    })
    return(
      stat['time-frame'] == 'daily' && stat['trackable-type'] == 'UserTeam' &&
        stat['trackable-id'] == chart['team-id'] && matchingTransitions.length
    )
  }
}

function filterStatisticTransitions(chart) {
  return function(transition) {
    return chart['statistic-transition-ids'].includes(transition.id)
  }
}

function filterStatisticGoals(chart) {
  return function(goal) {
    return chart['statistic-goal-ids'].includes(goal.id)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChartAndTable)
