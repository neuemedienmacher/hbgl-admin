import { connect } from 'react-redux'
import flatten from 'lodash/flatten'
import filter from 'lodash/filter'
import compact from 'lodash/compact'
import uniq from 'lodash/uniq'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import StatisticsContainer from '../components/StatisticsContainer'

const mapStateToProps = (state, ownProps) => {
  let currentUser = state.entities.users[state.entities['current-user-id']]
  let affectedUserIds = [currentUser.id] // add own id
  // add ids of all users of own teams
  affectedUserIds = affectedUserIds.concat(flatten(
    filter(
      state.entities['user-teams'],
      team => { return currentUser['user-team-ids'].includes(team.id) }
    ).map(team => { return flatten(team['user-ids']) })
  ))
  // add ids of all users in children-teams of led_teams (lead-only)
  affectedUserIds = affectedUserIds.concat(flatten(
    filter(
      state.entities['user-teams'],
      function(team) { return team['lead-id'] == currentUser.id }
    ).map(team => {
      return recursiveUserIdsOfTeam(team, state.entities)
    })
  ))
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
