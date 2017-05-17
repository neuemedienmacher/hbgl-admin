import { connect } from 'react-redux'
import BurnUpChart from '../../StatisticChartContainer/components/BurnUpChart'

const mapStateToProps = (state, ownProps) => {
  const formData = state.rform['StatisticChartForm'] || {}
  const startsAt = formData.starts_at || '2020-02-02'
  const endsAt = formData.ends_at || '2020-02-02'
  const targetCount = formData.target_count || 0

  const data = {
    actual: [],

    ideal: [{
      x: startsAt, y: 0,
    }, {
      x: endsAt, y: targetCount,
    }],

    projection: [],

    scope: [{
      x: startsAt, y: targetCount,
    }, {
      x: endsAt, y: targetCount,
    }],
  }
  // console.log('PreviewBurnUpChart container | data:', data)

  return {
    data
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChart)
