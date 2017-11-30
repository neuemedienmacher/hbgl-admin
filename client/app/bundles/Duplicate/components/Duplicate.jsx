import React, { PropTypes, Component } from 'react'
import LoadingForm from '../../GenericForm/containers/LoadingForm'

export default class Duplicate extends Component {
  render() {
    const { model, id, heading, modifySeedData, formStateDidMount } = this.props

    return(
      <div className='Duplicate'>
        <LoadingForm forceCreate
          modifySeedData={modifySeedData} model={model} id={id}
          formStateDidMount={formStateDidMount} formIdSpecification='duplicate'
        />
      </div>
    )
  }
}
