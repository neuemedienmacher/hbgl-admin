import React from 'react'
import TopicTable from '../containers/TopicTable'

export default class OrgaTopicOverviewPage extends React.Component {
  render() {
    return (
      <div className='jumbotron overview'>
        <h2>Organizationsübersicht Topics</h2>
        <TopicTable model='organization' columns='topics' />
        <p>
          <small>
            Hier findest du die Anzahl von Orgas, nach ihnen zugewiesenen
            Topics. Da eine Orga mehrere Topics haben kann, kann die
            Gesamtzahl kleiner sein als die Summe der Zeilen.
          </small>
        </p>
        <p>
          <small>
            In den einzelnen Städten werden die Orgas dann gezählt, wenn sie in
            der Stadt mindestens eine Division haben.
          </small>
        </p>
      </div>
    )
  }
}
