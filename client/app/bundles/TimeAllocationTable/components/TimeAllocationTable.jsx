import React, { PropTypes } from 'react'
import TimeSpanSelectionContainer from '../containers/TimeSpanSelectionContainer'
import TimeAllocationRowContainer from '../containers/TimeAllocationRowContainer'
import TimeAllocationHeaderContainer from '../containers/TimeAllocationHeaderContainer'

export default class Root extends React.Component {
  static propTypes = {
    users: PropTypes.arrayOf(PropTypes.object).isRequired,
    year: PropTypes.number.isRequired,
    week_number: PropTypes.number.isRequired,
  }

  render() {
    const { users, year, week_number } = this.props

    const rows = users.map(user => {
      return (
        <TimeAllocationRowContainer
          key={user.id} user={user} year={year} week_number={week_number}
        />
      )
    })

    return (
      <div className='content'>
        <h1>Ressourcentabelle</h1>
        <div className="TimeAllocationTable form-inline">
          <TimeSpanSelectionContainer year={year} week_number={week_number} />
          <table className='table table-condensed'>
            <tbody>
              <TimeAllocationHeaderContainer
                year={year} week_number={week_number}
              />
              {rows}
            </tbody>
          </table>
        </div>
      </div>
    )
  }
}
