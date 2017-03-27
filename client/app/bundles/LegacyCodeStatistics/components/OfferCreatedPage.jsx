import React from 'react'
import ChartPerUserAndDate from '../containers/ChartPerUserAndDateContainer'

export default class OfferCreatedPage extends React.Component {
  render() {
    return (
      <ChartPerUserAndDate
        title='Erstellte Angebote'
        model='Offer' field_end_value='created'
      />
    )
  }
}
