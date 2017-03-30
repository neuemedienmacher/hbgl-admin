import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import TeamStatisticCharts from '../components/TeamStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  let chartNames = ['completion', 'approval']
  const currentTeam =
    state.entities.user_teams[state.entities.current_user.current_team_id]
  const statisticCharts =
    buildAggregatedStatisticCharts(state.entities, currentTeam, chartNames)

  return {
    currentTeam,
    statisticCharts,
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
      user_ids: currentTeam.user_ids,
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

  loadData() {
    if(stateProps.currentTeam) {
      dispatchProps.dispatch(
        loadAjaxData(
          'statistic_charts',
          {
            'filters[user_id]': stateProps.currentTeam.user_ids,
            // NOTE: this loads the correct amount of data for now (every user has two charts)
            'per_page': stateProps.currentTeam.user_ids.length * 2
          },
          'teamStatisticCharts'
        )
      )
      dispatchProps.dispatch(
        loadAjaxData(
          'statistics',
          {
            'filters[user_id]': stateProps.currentTeam.user_ids,
            'filters[time_frame]': 'daily',
            'per_page': 9999
          },
          'teamStatistics'
        )
      )
    }
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  TeamStatisticCharts
)
