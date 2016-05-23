import { connect } from 'react-redux';
import BarChart from '../components/BarChart'

const mapStateToProps = function(state, ownProps) {
  return {
		statistics: state.statistics
	}
}

export default connect(mapStateToProps)(BarChart)
