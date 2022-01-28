import React, { Component } from 'react'
import { FormButton, JsonApiAdapter } from 'rform'

export default class Delete extends Component {
  render() {
    const { action, afterSuccess, afterError, model, id, location } = this.props

    return (
      <div className='content Delete'>
        <div className='jumbotron'>
          <p>
            Hinweis: Du bist im Begriff, ein Objekt fast unwiederbringlich zu
            löschen. Wenn du dir nicht sicher bist, ob du den nachfolgenden
            Button wirklich drücken solltest, dann tue das besser nicht.
          </p>
          <hr />
          <FormButton
            ajax
            action={action}
            method='DELETE'
            adapter={JsonApiAdapter}
            afterSuccess={afterSuccess}
            afterError={afterError}
            className='btn btn-danger'
          >
            Wech damit
          </FormButton>
        </div>
      </div>
    )
  }
}
