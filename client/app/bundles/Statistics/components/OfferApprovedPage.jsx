import React from 'react'
import ChartPerUserAndDate from '../containers/ChartPerUserAndDateContainer'

export default class OfferApprovedPage extends React.Component {
  render() {
    return (
      <ChartPerUserAndDate
        title='Freigeschaltete Angebote'
        model='Offer' field_end_value='approved'
      />
    )
  }
}
