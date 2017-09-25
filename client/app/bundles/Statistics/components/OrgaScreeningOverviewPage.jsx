import React from 'react'
import TopicTable from '../containers/TopicTable'

export default class OrgaScreeningOverviewPage extends React.Component {
  render() {
    return (
      <div className='jumbotron overview'>
        <h2>Organizationsübersicht (Screening zugewiesen)</h2>
        <TopicTable model='organization' columns='sections' />
        <p>
          <small>
            Hier findest du die Anzahl von Orgas, die Screening zugewiesen sind.
            Für einzelne Städte werden die Orgas gezählt, wenn sie in dieser
            Stadt mindestens eine Division haben.
          </small>
        </p>
      </div>
    )
  }
}
