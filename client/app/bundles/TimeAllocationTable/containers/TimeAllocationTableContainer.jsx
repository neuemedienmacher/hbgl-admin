import { connect } from 'react-redux'
import moment from 'moment'
import valuesIn from 'lodash/valuesIn'
import TimeAllocationTable from '../components/TimeAllocationTable'

const mapStateToProps = (state, ownProps) => ({
  users: valuesIn(state.entities.users),
  year: Number(ownProps.params.year) || moment().year(),
  week_number: Number(ownProps.params.week_number) || moment().week(),
})

const mapDispatchToProps = (dispatch, ownProps) => ({
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeAllocationTable)
