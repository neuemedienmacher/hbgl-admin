import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import ShowStatisticChart from '../components/ShowStatisticChart'

const mapStateToProps = (state, ownProps) => {
  return {
    statistic_chart: valuesIn(state.entities.statistic_charts).filter(goal =>
      goal.id == ownProps.params.id
    )[0],
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(ShowStatisticChart)
