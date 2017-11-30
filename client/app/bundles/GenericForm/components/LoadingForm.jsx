import React, { PropTypes } from 'react'
import Form from '../containers/Form'

export default class LoadingForm extends React.Component {
  // componentDidMount() {
  //   this.props.loadData()
  //   this.props.loadPossibleEvents()
  // }

  // componentWillReceiveProps(nextProps) {
  //   if (nextProps.model != this.props.model || nextProps.id != this.props.id ||
  //       nextProps.loadedOriginalData == false) {
  //     this.props.loadData(nextProps.model, nextProps.id)
  //   }
  // }

  render() {
    const { model, id, loadedOriginalData } = this.props

    if (!id || loadedOriginalData) {
      return <Form {...this.props} />
    } else {
      return <p>Loading...</p>
    }
  }
}
