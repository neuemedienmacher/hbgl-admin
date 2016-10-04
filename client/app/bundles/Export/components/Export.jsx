import React, { PropTypes, Component } from 'react'
import IndexHeader from '../../Index/containers/IndexHeader'
import ExportForm from '../containers/ExportForm'

export default class Export extends Component {
  componentWillReceiveProps(nextProps) {
    if (nextProps.location.query != this.props.location.query) {
      // this.props.loadData(nextProps.location.query, nextProps.model)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      location, model
    } = this.props

    return (
      <div className='content Export'>
        <h2>{`Export: ${model}`}</h2>
        <hr />
        <IndexHeader model={model} params={location.query} />
        <ExportForm model={model} params={location.query} />
      </div>
    )
  }
}
