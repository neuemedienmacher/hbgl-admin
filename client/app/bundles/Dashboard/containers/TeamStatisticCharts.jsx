import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import flatten from 'lodash/flatten'
import setUiAction from '../../../Backend/actions/setUi'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import PersonalOrTeamStatisticCharts from '../components/PersonalOrTeamStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  let user = state.entities.current_user
  const chartNames = ['completion', 'approval']
  const trackableId =
    state.ui.teamStatisticSelectedId || user.user_teams[0].id
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

  return {
    trackableId,
    statisticCharts,
    selectable_data,
    dataKey,
    dataLoaded,
    chartType: 'UserTeam'
  }
}

function buildAggregatedStatisticCharts(entities, currentTeam, chartNames) {
  let aggregatedStatisticCharts = []
  for (var i = 0; i < chartNames.length; i++) {
    let chartName = chartNames[i]
    let chartsOfTeamMembers = valuesIn(entities.statistic_charts).filter(
      chart => currentTeam.user_ids.includes(chart.user_id) && chart.title == chartName
    )
    if (!chartsOfTeamMembers.length) continue;

    let lastGoalIdsOfUserCharts = chartsOfTeamMembers.map(chart => {
      return chart.statistic_goal_ids[chart.statistic_goal_ids.length - 1]
    })
    // NOTE: we assume that this is the same for all user_charts
    let start_date = chartsOfTeamMembers[0].starts_at
    let end_date = chartsOfTeamMembers[0].ends_at
    aggregatedStatisticCharts.push({
      id: chartsOfTeamMembers[0].id, // NOTE: only used for key attribute - has to be uniq
      title: `${chartName} ${start_date.substr(0,4)} (${currentTeam.name})`,
      starts_at: start_date,
      ends_at: end_date,
      team_id: currentTeam.id,
      statistic_goal_ids: lastGoalIdsOfUserCharts,
      statistic_transition_ids: chartsOfTeamMembers[0].statistic_transition_ids // NOTE: we assume that these are the same for all user_charts
    })
  }
  return aggregatedStatisticCharts
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(newProps = stateProps) {
    // console.log('==> DATA LOAD!!!')
    let lowest_start_date = newProps.statisticCharts.map(chart => {
      return chart.starts_at
    }).sort((a, b) => +(a > b) || +(a === b) - 1)[0]
    dispatchProps.dispatch(
      loadAjaxData(
        'statistics',
        {
          'filters[trackable_id]': newProps.trackableId,
          'filters[trackable_type]': 'UserTeam',
          'filters[time_frame]': 'daily',
          'filters[date]': lowest_start_date,
          'operators[date]': '>=', // TODO? allow for ranges in filters and also filter <= ends_at ?!
          'per_page': 9999
        },
        newProps.dataKey
      )
    )
  },

  onSelect(e) {
    dispatchProps.dispatch(
      setUiAction('teamStatisticSelectedId', e.target.value)
    )
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  PersonalOrTeamStatisticCharts
)
