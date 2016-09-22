import React from 'react'
import ChartPerUserAndDate from '../containers/ChartPerUserAndDateContainer'

export default class OrgaCreatedPage extends React.Component {
  render() {
    return (
      <ChartPerUserAndDate
        title='Erstellte Orgas'
        model='Organization' field_end_value='created'
      />
    )
  }
}
