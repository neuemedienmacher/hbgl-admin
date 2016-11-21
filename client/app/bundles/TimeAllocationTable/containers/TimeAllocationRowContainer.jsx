import { connect } from 'react-redux'
import moment from 'moment'
import valuesIn from 'lodash/valuesIn'

import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import addEntities from '../../../Backend/actions/addEntities'
import TimeAllocationRow from '../components/TimeAllocationRow'

const mapStateToProps = (state, ownProps) => {
  const user_id = ownProps.user.id
  const week_number = ownProps.week_number
  const year = ownProps.year
  const [existing_wa, isHistorical, allocation] = getAllocationForWeekAndUser(
    valuesIn(state.entities.time_allocations), week_number, year, user_id
  )
  const [action, method] = getFormTarget(existing_wa, allocation)
  const [shortOrigin, originTitle] =
    getOriginText(existing_wa, isHistorical, allocation)

  const isPast = moment().year(year).week(week_number).isBefore(
    moment().startOf('week')
  )

  const seedData = { fields: {
    user_id, week_number, year,
    desired_wa_hours: allocation.desired_wa_hours,
    actual_wa_hours: allocation.actual_wa_hours,
    id: allocation.id,
  }}
  const actual_wa_comment = allocation.actual_wa_comment

  return {
    formId: ['TimeAllocation', user_id, year, week_number].join('-'),
    action,
    method,
    user_id,
    existing_wa,
    shortOrigin,
    originTitle,
    isPast,
    seedData,
    actual_wa_comment,
  }
}

function getFormTarget(isEdit, allocation) {
  if (isEdit) {
    return [`/api/v1/time_allocations/${allocation.id}`, 'PATCH']
  } else {
    return ['/api/v1/time_allocations', 'POST']
  }
}

function getOriginText(existing_wa, isHistorical, allocation) {
  if (existing_wa) {
    return ['Diese KW', 'In der aktuell gewählten KW neu bestimmt.']
  } else if (isHistorical) {
    return [
      `KW${allocation.week_number}/${allocation.year}`,
      'Aus der nächsten historischen KW übernommene Zeit.'
    ]
  } else {
    return ['keine', 'Es gibt für diesen Nutzer keine früheren Daten']
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  handleResponse: (_formId, data) => dispatch(addEntities(data))
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeAllocationRow)
