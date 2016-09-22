import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import ShowProductivityGoal from '../components/ShowProductivityGoal'

const mapStateToProps = (state, ownProps) => {
  return {
    productivity_goal: valuesIn(state.productivity_goals).filter(goal =>
      goal.id == ownProps.params.id
    )[0],
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(ShowProductivityGoal)
