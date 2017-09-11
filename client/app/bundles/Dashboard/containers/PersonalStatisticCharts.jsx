import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import flatten from 'lodash/flatten'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import PersonalOrTeamStatisticCharts from '../components/PersonalOrTeamStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  const chartType = 'User'
  let selectIdentifier = 'controlled-select-view-' + chartType + 'Statistics'
  const trackableId =
    state.ui[selectIdentifier] || state.entities['current-user-id']
  const dataKey = 'personalStatistics#' + trackableId
  const statisticCharts = valuesIn(state.entities['statistic-charts']).filter(
    chart => chart['user-id'] == trackableId
  )
  let currentUser = state.entities.users[state.entities['current-user-id']]
  let selectableData = [[currentUser.id, currentUser.name]]
  // append userIds of users in ledTeams
  let ledTeams = valuesIn(state.entities['user-teams']).filter(
    t => currentUser['led-team-ids'] && currentUser['led-team-ids'].includes(t.id)
  )
  selectableData = selectableData.concat(
    ledTeams ?
    flatten(ledTeams.map(team => {
      return team['user-ids'] ? team['user-ids'].map(userId => {
        return [userId, `${state.entities.users[userId].name} (${team.name})`]
      }) : []
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
          'filters[trackable-id]': newProps.trackableId,
          'filters[trackable-type]': 'User',
          'filters[time-frame]': 'daily',
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
