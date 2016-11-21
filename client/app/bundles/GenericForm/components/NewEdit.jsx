import React, { PropTypes } from 'react'
import Form from '../containers/Form'

export default class NewEdit extends React.Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      heading, model, editId, loadedOriginalData,
    } = this.props

    return (
      <div className={`content NewEdit ${model}`}>
        <h2>{heading}</h2>
        {this.renderLoadingOrForm(model, editId, loadedOriginalData)}
      </div>
    )
  }

  renderLoadingOrForm(model, editId, loadedOriginalData) {
    if (!editId || loadedOriginalData) {
      return <Form model={model} editId={editId} />
    } else {
      return <p>Loading...</p>
    }
  }
}
