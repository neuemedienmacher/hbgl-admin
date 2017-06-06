import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import flatten from 'lodash/flatten'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import PersonalOrTeamStatisticCharts from '../components/PersonalOrTeamStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  let user = state.entities.current_user
  const chartType = 'UserTeam'
  const chartNames = ['completion', 'approval']
  let selectIdentifier = 'controlled-select-view-' + chartType + 'Statistics'
  const trackableId = state.ui[selectIdentifier] || user.user_teams[0].id
  const dataKey = 'teamStatistics#' + trackableId
  const statisticCharts = buildAggregatedStatisticCharts(
    state.entities, state.entities.user_teams[trackableId], chartNames
  )
  let selectable_data = !user.user_teams ? [] : (
    user.user_teams.map(team => {
      return [team.id, team.name]
    })
  )
  selectable_data = selectable_data.concat(
    !user.led_teams ? [] : (
      flatten(user.led_teams.map(led_team => {
        return !led_team.children ? [] : led_team.children.map(child_team =>{
          return [child_team.id, `${child_team.name} (SubTeam von: ${led_team.name})`]
        })
      })
    ))
  )

  const dataLoaded = state.ajax.isLoading[dataKey] === false &&
                     state.ajax[dataKey]
  const dataPercentage = !state.ajax[dataKey] ? '0 %' :
    ((state.ajax[dataKey].meta.current_page / state.ajax[dataKey].meta.total_pages) * 100).toFixed(2) + ' %'
  return {
    trackableId,
    statisticCharts,
    selectable_data,
    dataKey,
    dataLoaded,
    chartType,
    dataPercentage
  }
}

function buildAggregatedStatisticCharts(entities, currentTeam, chartNames) {
  let aggregatedStatisticCharts = []
  for (var i = 0; i < chartNames.length; i++) {
    let affectedUserIds = recursive_user_ids_of_team(currentTeam)
    let chartName = chartNames[i]
    let chartsOfAffectedUsers = valuesIn(entities.statistic_charts).filter(
      chart => chart.title == chartName && affectedUserIds.includes(chart.user_id)
    )
    if (!chartsOfAffectedUsers.length) continue;

    let lastGoalIdsOfUserCharts = chartsOfAffectedUsers.map(chart => {
      return chart.statistic_goal_ids[chart.statistic_goal_ids.length - 1]
    })
    // NOTE: we assume that this is the same for all user_charts
    let start_date = chartsOfAffectedUsers[0].starts_at
    let end_date = chartsOfAffectedUsers[0].ends_at
    aggregatedStatisticCharts.push({
      id: chartsOfAffectedUsers[0].id, // NOTE: only used for key attribute - has to be uniq
      title: `${chartName} ${start_date.substr(0,4)} (${currentTeam.name})`,
      starts_at: start_date,
      ends_at: end_date,
      team_id: currentTeam.id,
      statistic_goal_ids: lastGoalIdsOfUserCharts,
      statistic_transition_ids: chartsOfAffectedUsers[0].statistic_transition_ids // NOTE: we assume that these are the same for all user_charts
    })
  }
  return aggregatedStatisticCharts
}

function recursive_user_ids_of_team(team) {
  let ids = team.user_ids || []
  ids = ids.concat(
    team.children && team.children.length != 0 ? team.children.map(s_team => {
        return recursive_user_ids_of_team(s_team)
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
    let lowest_start_date = newProps.statisticCharts.map(chart => {
      return chart.starts_at
    }).sort((a, b) => +(a > b) || +(a === b) - 1)[0]
    let page = newProps.dataLoaded != undefined && newProps.dataLoaded.meta ?
      newProps.dataLoaded.meta.current_page + 1 : 1
    dispatchProps.dispatch(
      loadAjaxData(
        'statistics',
        {
          'filters[trackable_id]': newProps.trackableId,
          'filters[trackable_type]': 'UserTeam',
          'filters[time_frame]': 'daily',
          'filters[date]': lowest_start_date,
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
