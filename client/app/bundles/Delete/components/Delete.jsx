import React, { PropTypes, Component } from 'react'
import { FormButton, JsonApiAdapter } from 'rform'
import MemberActionsNavBar from
  '../../MemberActionsNavBar/containers/MemberActionsNavBar'

export default class Delete extends Component {
  render() {
    const {
      action, afterSuccess, afterError, model, id, location
    } = this.props

    return(
      <div className='content Delete'>
        <MemberActionsNavBar model={model} id={id} location={location} />
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
