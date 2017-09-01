import React, { PropTypes } from 'react'
import LoadingForm from '../containers/LoadingForm'
import MemberActionsNavBar from
  '../../MemberActionsNavBar/containers/MemberActionsNavBar'

export default class Standalone extends React.Component {
  render() {
    const { model, editId, location } = this.props

    return(
      <div className={`content Standalone ${model}`}>
        <MemberActionsNavBar model={model} id={editId} location={location} />
        <LoadingForm model={model} editId={editId} />
      </div>
    )
  }
}
