import React from 'react'
import OverviewTable from '../containers/OverviewTable'

export default class OfferOverviewPage extends React.Component {
  render() {
    return (
      <div className='jumbotron overview'>
        <h2>Angebotsübersicht</h2>
        <OverviewTable model='offer' cityAssociationName='city' />
        <p>
          <small>
            Hier findest du die Anzahl von Angeboten, die in einem state und
            einer clarat Welt existieren. Und dann noch die Anzahl von
            Angeboten pro state insgesamt, unabhängig von Welten. Optional
            können diese Werte nach einer Stadt gefiltert werden.
          </small>
        </p>
        <p>
          <small>
            Beachte, dass es auch noch Angebote
            in mehreren Welten gibt ("Zwischenweltangebote"). Somit ist Spalte
            2 plus Spalte 3 nicht unbedingt gleich Spalte 4.
          </small>
        </p>
      </div>
    )
  }
}
