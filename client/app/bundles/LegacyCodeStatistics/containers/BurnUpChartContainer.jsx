import { connect } from 'react-redux'
import BurnUpChart from '../../StatisticChartContainer/components/BurnUpChart'

const mapStateToProps = function(state, ownProps) {
  return {
    data: {
      actual: [{
        x: '2016-05-04', y: 0,
      }, {
        x: '2016-05-05', y: 4,
      }, {
        x: '2016-05-06', y: 7,
      }, {
        x: '2016-05-10', y: 10,
      }],

      ideal: [{
        x: '2016-05-04', y: 0,
      }, {
        x: '2016-06-04', y: 100,
      }],

      projection: [{
        x: '2016-05-04', y: 0,
      }, {
        x: '2016-06-24', y: 100,
      }],

      scope: [{
        x: '2016-05-04', y: 90,
      }, {
        x: '2016-05-06', y: 90,
      }, {
        x: '2016-05-06', y: 100,
      }, {
        x: '2016-06-24', y: 100,
      }],

    }
	}
}

const mapDispatchToProps = function(dispatch, ownProps) {
  return { }
}

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChart)
