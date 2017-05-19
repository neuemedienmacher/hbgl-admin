import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import flatten from 'lodash/flatten'
import filter from 'lodash/filter'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import PersonalOrTeamStatisticCharts from '../components/PersonalOrTeamStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  let user = state.entities.users[state.entities['current-user-id']]
  let userTeams = filter(
    state.entities['user-teams'],
    team => { return user['user-team-ids'].includes(team.id) }
  )
  const chartType = 'UserTeam'
  const chartNames = ['completion', 'approval']
  let selectIdentifier = 'controlled-select-view-' + chartType + 'Statistics'
  const trackableId = state.ui[selectIdentifier] || userTeams[0].id
  const dataKey = 'teamStatistics#' + trackableId
  const statisticCharts = buildAggregatedStatisticCharts(
    state.entities, state.entities['user-teams'][trackableId], chartNames
  )
  let selectableData = userTeams.map(team => {
    return [team.id, team.name]
  })
  selectableData = selectableData.concat(flatten(
    filter(
      state.entities['user-teams'], team => { return team['lead-id'] == user.id }
    ).map(ledTeam => {
      let children = filter(
        entities['user-teams'],
        otherTeam => { return otherTeam['parent-id'] == ledTeam.id }
      )
      return children.map(childTeam => {
        return [childTeam.id, `${childTeam.name} (SubTeam von: ${ledTeam.name})`]
      })
    })
  ))

  const dataLoaded = state.ajax.isLoading[dataKey] === false &&
                     state.ajax[dataKey]
  const dataPercentage = !state.ajax[dataKey] ? '0 %' :
    ((state.ajax[dataKey].meta.current_page / state.ajax[dataKey].meta.total_pages) * 100).toFixed(2) + ' %'
  return {
    trackableId,
    statisticCharts,
    selectableData,
    dataKey,
    dataLoaded,
    chartType,
    dataPercentage
  }
}

function buildAggregatedStatisticCharts(entities, currentTeam, chartNames) {
  let aggregatedStatisticCharts = []
  for (var i = 0; i < chartNames.length; i++) {
    let affectedUserIds = recursiveUserIdsOfTeam(currentTeam, entities)
    let chartName = chartNames[i]
    let chartsOfAffectedUsers = valuesIn(entities['statistic-charts']).filter(
      chart => chart.title == chartName && affectedUserIds.includes(chart['user-id'])
    )
    if (!chartsOfAffectedUsers.length) continue;

    let lastGoalIdsOfUserCharts = chartsOfAffectedUsers.map(chart => {
      return chart['statistic-goal-ids'][chart['statistic-goal-ids'].length - 1]
    })
    // NOTE: we assume that this is the same for all user_charts
    let startDate = chartsOfAffectedUsers[0]['starts-at']
    let endDate = chartsOfAffectedUsers[0]['ends-at']
    aggregatedStatisticCharts.push({
      id: chartsOfAffectedUsers[0].id, // NOTE: only used for key attribute - has to be uniq
      title: `${chartName} ${startDate.substr(0,4)} (${currentTeam.name})`,
      'starts-at': startDate,
      'ends-at': endDate,
      'team-id': currentTeam.id,
      'statistic-goal-ids': lastGoalIdsOfUserCharts,
      'statistic-transition-ids': chartsOfAffectedUsers[0]['statistic-transition-ids'] // NOTE: we assume that these are the same for all user_charts
    })
  }
  return aggregatedStatisticCharts
}

function recursiveUserIdsOfTeam(team, entities) {
  let ids = team['user-ids'] || []
  let children = filter(
    entities['user-teams'],
    otherTeam => { return otherTeam['parent-id'] == team.id }
  )
  ids = ids.concat(
    children.length != 0 ? children.map(subTeam => {
      return recursiveUserIdsOfTeam(subTeam, entities)
    }) : []
  )
  return flatten(ids)
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(newProps = stateProps) {
    let lowestStartDate = newProps.statisticCharts.map(chart => {
      return chart['starts-at']
    }).sort((a, b) => +(a > b) || +(a === b) - 1)[0]
    let page = newProps.dataLoaded != undefined && newProps.dataLoaded.meta ?
      newProps.dataLoaded.meta.current_page + 1 : 1
    dispatchProps.dispatch(
      loadAjaxData(
        'statistics',
        {
          'filters[trackable-id]': newProps.trackableId,
          'filters[trackable-type]': 'UserTeam',
          'filters[time-frame]': 'daily',
          'filters[date]': lowestStartDate,
          'operators[date]': '>=', // TODO? allow for ranges in filters and also filter <= ends_at ?!
          'per_page': 50,
          'page': page
        },
        newProps.dataKey
      )
    )
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  PersonalOrTeamStatisticCharts
)
