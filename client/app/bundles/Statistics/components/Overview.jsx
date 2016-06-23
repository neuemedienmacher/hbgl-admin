import React, { PropTypes } from 'react'

export default class Overview extends React.Component {
  static propTypes = {}

  render() {
    console.log('Overview context', this.context)
    return (
      <div className='jumbotron'>
        <h1>Zahlen und Linien!</h1>
        <p>
          Hier geht es zu den verschiedenen Statistiken, die wir über clarat
          sammeln. Eventuell kannst du nicht alle sehen. Such dir im Menü
          rechts etwas aus, was dich interessiert.
        </p>
      </div>
    )
  }
}
