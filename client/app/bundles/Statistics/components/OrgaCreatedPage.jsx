import React from 'react'
import ChartPerUserAndDate from '../containers/ChartPerUserAndDateContainer'

export default class OrgaCreatedPage extends React.Component {
  render() {
    return (
      <ChartPerUserAndDate
        title='Erstellte Orgas' topic='organization_created' />
    )
  }
}
