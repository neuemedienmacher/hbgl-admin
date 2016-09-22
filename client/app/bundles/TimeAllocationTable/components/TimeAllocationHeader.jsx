import React, { PropTypes } from 'react'

export default class TimeAllocationHeader extends React.Component {
  static propTypes = {
    isPast: PropTypes.bool.isRequired,
  }

  render() {
    const { isPast } = this.props

    const actualHoursCell = isPast ? (
      <th>W&A Stunden IST</th>
    ) : null

    return (
      <tr>
        <th>Nutzer</th>
        <th>Info-Herkunft</th>
        <th>W&A Stunden SOLL</th>
        {actualHoursCell}
        <th>Aktion</th>
      </tr>
    )
  }
}
