import React, { PropTypes } from 'react'

export default class Overview extends React.Component {
  static propTypes = {}

  render() {
    return (
      <div className='jumbotron'>
        <h1>Zahlen und Linien!</h1>
        <p>
          Hier geht es zu verschiedenen allgemeinen Statistiken, die wir über
          clarat sammeln. Produktivitätsziele haben noch einen separaten
          Bereich.
        </p>
      </div>
    )
  }
}
