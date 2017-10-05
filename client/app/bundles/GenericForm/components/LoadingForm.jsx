import React, { PropTypes } from 'react'
import Form from '../containers/Form'

export default class LoadingForm extends React.Component {
  componentDidMount() {
    this.props.loadData()
    this.props.loadPossibleEvents()
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.model != this.props.model || nextProps.editId != this.props.editId ||
        nextProps.loadedOriginalData == false) {
      this.props.loadData(nextProps.model, nextProps.editId)
      this.props.loadPossibleEvents(nextProps.model, nextProps.editId)
    }
  }

  render() {
    const { model, editId, loadedOriginalData } = this.props

    if (!editId || loadedOriginalData) {
      return <Form {...this.props} />
    } else {
      return <p>Loading...</p>
    }
  }
}
