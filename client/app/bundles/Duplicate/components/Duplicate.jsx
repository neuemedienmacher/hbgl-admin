import React, { PropTypes, Component } from 'react'
import LoadingForm from '../../GenericForm/containers/LoadingForm'
import MemberActionsNavBar from
  '../../MemberActionsNavBar/containers/MemberActionsNavBar'


export default class Duplicate extends Component {
  render() {
    const {
      model, id, heading, modifySeedData, formStateDidMount, location
    } = this.props

    return(
      <div className='content Duplicate'>
        <MemberActionsNavBar model={model} id={id} location={location} />
        <LoadingForm forceCreate
          modifySeedData={modifySeedData} model={model} editId={id}
          formStateDidMount={formStateDidMount} formIdSpecification='duplicate'
        />
      </div>
    )
  }
}
