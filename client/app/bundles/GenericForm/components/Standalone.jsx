import React, { PropTypes, Component } from 'react'
import LoadingForm from '../containers/LoadingForm'

export default class Standalone extends Component {
  render() {
    const { model, id, location } = this.props

    return(
      <div className={`content Standalone ${model}`}>
        <LoadingForm model={model} id={id} />
      </div>
    )
  }
}
