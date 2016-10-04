import { connect } from 'react-redux'
import moment from 'moment'
import TimeAllocationHeader from '../components/TimeAllocationHeader'

const mapStateToProps = (state, ownProps) => {
  console.log(state)
  return {
    isPast: moment().year(ownProps.year).week(ownProps.week_number).isBefore(
      moment().startOf('week')
    ),
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(TimeAllocationHeader)
