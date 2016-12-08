import React from 'react'
import OverviewTable from '../containers/OverviewTable'

export default class OrgaOverviewPage extends React.Component {
  render() {
    return (
      <div className='jumbotron overview'>
        <h2>Organizationsübersicht</h2>
        <OverviewTable model='organization' />
        <p>
          <small>
            Hier findest du die Anzahl von Orgas, die in einem state und
            einer clarat Welt existieren. Und dann noch die Anzahl von allen
            Orgas pro state, unabhängig von Welten.
          </small>
        </p>
        <p>
          <small>
            Beachte, Organisationen sind nicht direkt einer Welt zugeordnet.
            Eine Orga "hat eine Welt", sobald sie ein Angebot in dieser Welt
            hat. Es gibt also auch Orgas die noch keine Welt haben. Diese
            werden nur in Spalte 4 gezählt.
          </small>
        </p>
        <p>
          <small>
            Es gibt auch welche, die mehrere Welten haben. Diese werden dann
            in Spalte 2 <i>und</i> Spalte 3 gezählt, aber nur einmal in Spalte
            4.
          </small>
        </p>
      </div>
    )
  }
}
