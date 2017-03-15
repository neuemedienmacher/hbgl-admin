import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import PersonalStatisticCharts from '../components/PersonalStatisticCharts'

const mapStateToProps = (state, ownProps) => {
  const currentUserId = state.entities.current_user.id
  let statisticCharts = valuesIn(state.entities.statistic_charts).filter(
    chart => chart.user_id == currentUserId
  )

  return {
    currentUserId,
    statisticCharts,
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
        { 'filters[user_id]': stateProps.currentUserId },
        'personalStatisticCharts'
      )
    )
    dispatchProps.dispatch(
      loadAjaxData(
        'statistics',
        {
          'filters[user_id]': stateProps.currentUserId,
          'filters[time_frame]': 'daily',
          'per_page': 9999
        },
        'personalStatistics'
      )
    )
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  PersonalStatisticCharts
)
