import React, { PropTypes } from 'react'
import Form from '../containers/Form'

export default class LoadingForm extends React.Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const { model, editId, loadedOriginalData } = this.props

    if (!editId || loadedOriginalData) {
      return <Form model={model} editId={editId} />
    } else {
      return <p>Loading...</p>
    }
  }
}
