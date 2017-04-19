import React, { PropTypes } from 'react'
import LoadingForm from '../containers/LoadingForm'

export default class Standalone extends React.Component {
  render() {
    const { heading, model, editId } = this.props

    return(
      <div className={`content Standalone ${model}`}>
        <h2>{heading}</h2>
        <LoadingForm model={model} editId={editId} />
      </div>
    )
  }
}
