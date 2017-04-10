import React from 'react'
import ChartPerUserAndDate from '../containers/ChartPerUserAndDateContainer'

export default class OrgaApprovedPage extends React.Component {
  render() {
    return (
      <ChartPerUserAndDate
        title='Freigeschaltete Orgas'
        model='Organization' field_end_value='approved'
      />
    )
  }
}
