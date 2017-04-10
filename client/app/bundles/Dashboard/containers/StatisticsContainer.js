import { connect } from 'react-redux'
import flatten from 'lodash/flatten'
import compact from 'lodash/compact'
import uniq from 'lodash/uniq'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import setUiAction from '../../../Backend/actions/setUi'
import StatisticsContainer from '../components/StatisticsContainer'

const mapStateToProps = (state, ownProps) => {
  let current_user = state.entities.current_user
  let affectedUserIds = [current_user.id] // add own id
  // add ids of all users of own teams
  affectedUserIds = affectedUserIds.concat(flatten(
    current_user.user_teams.map(team => { return flatten(team.user_ids) })
  ))
  // add ids of all users in children-teams of led_teams (lead-only)
  affectedUserIds = affectedUserIds.concat(
    flatten(current_user.led_teams.map(team => {
      return flatten(team.children.map(child_team => {
        return flatten(child_team.user_ids)
      }))
    }))
  )
  affectedUserIds = compact(uniq(affectedUserIds))

  const selectedTab = state.ui.statisticSelectedTab || 0
  const dataLoaded = state.ajax.overallStatisticChartData &&
                     state.ajax.isLoading.overallStatisticChartData === false &&
                     state.entities.statistic_charts &&
                     state.entities.statistic_charts.length != 0

  return {
    affectedUserIds,
    selectedTab,
    dataLoaded
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData() {
    dispatchProps.dispatch(
      loadAjaxData(
        'statistic_charts',
        {
          'filters[user_id]': stateProps.affectedUserIds,
          // NOTE: this loads the correct amount of data for now (every user has two charts at max)
          'per_page': stateProps.affectedUserIds.length * 2
        },
        'overallStatisticChartData'
      )
    )
  },

  handleSelect(e){
    if (stateProps.selectedTab != e) {
      dispatchProps.dispatch(
        setUiAction('statisticSelectedTab', e)
      )
    }
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  StatisticsContainer
)
