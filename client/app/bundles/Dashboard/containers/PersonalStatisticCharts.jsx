import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import flatten from 'lodash/flatten'
import setUiAction from '../../../Backend/actions/setUi'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import PersonalOrTeamStatisticCharts from '../components/PersonalOrTeamStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  const trackableId =
    state.ui.personalStatisticSelectedId || state.entities.current_user.id
  const dataKey = 'personalStatistics#' + trackableId
  const statisticCharts = valuesIn(state.entities.statistic_charts).filter(
    chart => chart.user_id == trackableId
  )
  let selectable_data =
    [[state.entities.current_user.id, state.entities.current_user.name]]
  // append user_ids of users in led_teams
  selectable_data = selectable_data.concat(
    state.entities.current_user.led_teams ?
    flatten(state.entities.current_user.led_teams.map(team => {
      return team.user_ids.map(user_id => {
        return [user_id, `${state.entities.users[user_id].name} (${team.name})`]
      })
    })) : []
  )
  // append user_ids of leads of child_teams of led_teams.. yes, really..
  selectable_data = selectable_data.concat(
    state.entities.current_user.led_teams ?
    flatten(state.entities.current_user.led_teams.map(team => {
      return !team.children ? [] : team.children.map(c_team => {
        return c_team.lead_id ? [c_team.lead_id, `${state.entities.users[c_team.lead_id].name} (Lead von: ${c_team.name})`] : []
      })
    })) : []
  )
  const dataLoaded = state.ajax.isLoading[dataKey] === false &&
                     state.ajax[dataKey]
  return {
    trackableId,
    statisticCharts,
    selectable_data,
    dataKey,
    dataLoaded,
    chartType: 'User'
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
    // console.log('==> DATA LOAD!!!')
    let lowest_start_date = newProps.statisticCharts.map(chart => {
      return chart.starts_at
    }).sort((a, b) => +(a > b) || +(a === b) - 1)[0]
    dispatchProps.dispatch(
      loadAjaxData(
        'statistics',
        {
          'filters[trackable_id]': newProps.trackableId,
          'filters[trackable_type]': 'User',
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
      setUiAction('personalStatisticSelectedId', e.target.value)
    )
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  PersonalOrTeamStatisticCharts
)
