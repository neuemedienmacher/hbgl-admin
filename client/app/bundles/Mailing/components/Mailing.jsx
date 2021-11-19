import React, { Component } from 'react'
import { FormButton, JsonApiAdapter } from 'rform'

export default class Mailing extends Component {
  componentDidMount() {
    this.props.loadData()
  }
  render() {
    const {
      action,
      afterSuccess,
      afterError,
      authToken,
      showSendButton,
      explanationText,
    } = this.props

    return (
      <div className='content Delete'>
        <div className='jumbotron'>
          <p>{'Hinweis: ' + explanationText}</p>
          <hr />
          {showSendButton && (
            <FormButton
              ajax
              action={action}
              method='POST'
              adapter={JsonApiAdapter}
              afterSuccess={afterSuccess}
              afterError={afterError}
              className='btn btn-danger'
              disabled={!showSendButton}
            >
              Mail versenden!
            </FormButton>
          )}
        </div>
      </div>
    )
  }
}
