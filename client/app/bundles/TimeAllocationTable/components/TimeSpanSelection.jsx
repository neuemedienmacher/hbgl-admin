import React, { PropTypes } from 'react'

export default class TimeSpanSelection extends React.Component {
  static propTypes = {
    start_year: PropTypes.number.isRequired,
    years: PropTypes.array.isRequired,
    week_numbers: PropTypes.array.isRequired,
  }

  render() {
    const {
      years, week_numbers, selected_year, selected_week_number, selectedWeek,
      onWeekNumberChange, onYearChange, onTodayClick, onNextMonthClick,
      onPlusClick, onMinusClick,
    } = this.props

    return (
      <div className='row'>
        <div className='col-sm-3 text-center'>
          <div className='form-group'>
            <label htmlFor='year'>Jahr</label>
            <select
              id='year'
              className='form-control'
              name='time_allocation[year]'
              value={selected_year}
              onChange={onYearChange}
            >
              {years.map(year =>
                <option key={year} value={year}>{year}</option>
              )}
            </select>
          </div>
          {' '}
          <div className='form-group'>
            <label htmlFor='wn'>KW</label>
            <select
              id='wn'
              className='form-control'
              name='time_allocation[week_number]'
              value={selected_week_number}
              onChange={onWeekNumberChange}
            >
              {week_numbers.map(wn =>
                <option key={wn} value={wn}>{wn}</option>
              )}
            </select>
          </div>
        </div>
        <div className='col-sm-5 text-center'>
          <button onClick={onTodayClick} className='btn btn-default btn-xs'>
            Aktuelle KW
          </button>
          {' '}
          <button onClick={onNextMonthClick} className='btn btn-default btn-xs'>
            Anfang nächster Monat
          </button>
          {' '}
          <button onClick={onPlusClick} className='btn btn-default btn-xs'>
            KW+
          </button>
          {' '}
          <button onClick={onMinusClick} className='btn btn-default btn-xs'>
            KW-
          </button>
        </div>
        <div className='col-sm-4 text-center'>
          {selectedWeek.format('DD.MM.YYYY') + ' - ' +
            selectedWeek.endOf('week').format('DD.MM.YYYY')}
        </div>
      </div>
    )
  }
}
