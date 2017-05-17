import { connect } from 'react-redux'
import flatten from 'lodash/flatten'
import compact from 'lodash/compact'
import uniq from 'lodash/uniq'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import StatisticsContainer from '../components/StatisticsContainer'

const mapStateToProps = (state, ownProps) => {
  let currentUser = state.entities['current-user']
  let affectedUserIds = [currentUser.id] // add own id
  // add ids of all users of own teams
  affectedUserIds = affectedUserIds.concat(flatten(
    currentUser['user-teams'].map(team => { return flatten(team['user-ids']) })
  ))
  // add ids of all users in children-teams of led_teams (lead-only)
  affectedUserIds = affectedUserIds.concat(
    flatten(currentUser['led-teams'].map(team => {
      return recursiveUserIdsOfTeam(team)
    }))
  )
  affectedUserIds = compact(uniq(affectedUserIds))

  const dataLoaded = state.ajax.overallStatisticChartData &&
                     state.ajax.isLoading.overallStatisticChartData === false &&
                     state.entities['statistic-charts'] &&
                     state.entities['statistic-charts'].length != 0

  return {
    affectedUserIds,
    dataLoaded
  }
}

function recursiveUserIdsOfTeam(team) {
  let ids = team['user-ids'] || []
  ids = ids.concat(
    team.children && team.children.length != 0 ? team.children.map(s_team => {
        return recursiveUserIdsOfTeam(s_team)
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

  loadData() {
    dispatchProps.dispatch(
      loadAjaxData(
        'statistic-charts',
        {
          'filters[user-id]': stateProps.affectedUserIds,
          // NOTE: this loads the correct amount of data for now (every user has two charts at max)
          'per_page': stateProps.affectedUserIds.length * 2
        },
        'overallStatisticChartData'
      )
    )
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  StatisticsContainer
)
