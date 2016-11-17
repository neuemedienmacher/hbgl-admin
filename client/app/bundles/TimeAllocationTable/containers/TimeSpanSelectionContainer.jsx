import { connect } from 'react-redux'
import range from 'lodash/range'
import moment from 'moment'
import { browserHistory } from 'react-router'
import TimeSpanSelection from '../components/TimeSpanSelection'

const mapStateToProps = (state, ownProps) => {
  const selected_year = ownProps.year
  const selected_week_number = ownProps.week_number
  const start_year = state.settings.time_allocations.start_year

  return {
    start_year,
    years: range(start_year, start_year + 6),
    selected_year,
    week_numbers: range(1, 53),
    selected_week_number,
    selectedWeek:
      moment().year(selected_year).week(selected_week_number).startOf('week'),
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onYearChange: (e) => {
    browserHistory.push(`/time_allocations/${e.target.value}/${ownProps.week_number}`)
  },

  onWeekNumberChange: (e) => {
    browserHistory.push(`/time_allocations/${ownProps.year}/${e.target.value}`)
  },

  onTodayClick: (_e) => {
    const [year, wn] = [moment().year(), moment().week()]
    browserHistory.push(`/time_allocations/${year}/${wn}`)
  },

  onNextMonthClick: (_e) => {
    const year = moment().year()
    const wn = moment().add(1, 'months').date(1).week()
    browserHistory.push(`/time_allocations/${year}/${wn}`)
  },

  onPlusClick: (_e) => {
    const nextMoment =
      moment().year(ownProps.year).week(ownProps.week_number).add(1, 'weeks')
    const [year, wn] = [nextMoment.year(), nextMoment.week()]
    browserHistory.push(`/time_allocations/${year}/${wn}`)
  },

  onMinusClick: (_e) => {
    const nextMoment =
      moment().year(ownProps.year).week(ownProps.week_number).subtract(1, 'weeks')
    const [year, wn] = [nextMoment.year(), nextMoment.week()]
    browserHistory.push(`/time_allocations/${year}/${wn}`)
  },
})

export default connect(mapStateToProps, mapDispatchToProps)(TimeSpanSelection)
