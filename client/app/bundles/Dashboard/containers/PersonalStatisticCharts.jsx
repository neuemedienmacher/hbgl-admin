import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import flatten from 'lodash/flatten'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import PersonalOrTeamStatisticCharts from '../components/PersonalOrTeamStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  const chartType = 'User'
  let selectIdentifier = 'controlled-select-view-' + chartType + 'Statistics'
  const trackableId =
    state.ui[selectIdentifier] || state.entities.current_user.id
  const dataKey = 'personalStatistics#' + trackableId
  const statisticCharts = valuesIn(state.entities.statistic_charts).filter(
    chart => chart.user_id == trackableId
  )
  let selectableData =
    [[state.entities.current_user.id, state.entities.current_user.name]]
  // append user_ids of users in led_teams
  selectableData = selectableData.concat(
    state.entities.current_user.led_teams ?
    flatten(state.entities.current_user.led_teams.map(team => {
      return team.user_ids.map(user_id => {
        return [user_id, `${state.entities.users[user_id].name} (${team.name})`]
      })
    })) : []
  )
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
          'filters[trackable_type]': 'User',
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
