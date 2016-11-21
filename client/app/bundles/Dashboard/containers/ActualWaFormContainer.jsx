import { connect } from 'react-redux'
import moment from 'moment'
import addEntities from '../../../Backend/actions/addEntities'
import ActualWaForm from '../components/ActualWaForm'

const mapStateToProps = (state, ownProps) => {
  const ta = ownProps.time_allocation
  const week = moment().week(ta.week_number).year(ta.year)

  return {
    startDate: week.startOf('week').format('DD.MM.YYYY'),
    endDate: week.endOf('week').format('DD.MM.YYYY'),
    action: `/api/v1/time_allocations/${ta.year}/${ta.week_number}`,
    formId: ['ActualWaForm', ta.week_number].join('-'),
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  handleResponse: (_formId, data) => dispatch(addEntities(data)),
})

export default connect(mapStateToProps, mapDispatchToProps)(ActualWaForm)
