import React, { PropTypes, Component } from 'react'
import { FormButton, JsonApiAdapter } from 'rform'

export default class Delete extends Component {
  render() {
    const {
      action, heading, afterSuccess, afterError,
    } = this.props

    return(
      <div className='content Delete'>
        <h3 className="page-title">{heading}</h3>
        <FormButton ajax
          action={action} method='DELETE' adapter={JsonApiAdapter}
          afterSuccess={afterSuccess} afterError={afterError}
        >
          Wech damit
        </FormButton>
      </div>
    )
  }
}
