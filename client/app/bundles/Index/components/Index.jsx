import React, { PropTypes, Component } from 'react'
import IndexHeader from '../containers/IndexHeader'
import IndexTable from '../containers/IndexTable'
import Pagination from '../containers/Pagination'

export default class Index extends Component {
  componentWillReceiveProps(nextProps) {
    if (nextProps.location.query != this.props.location.query) {
      this.props.loadData(nextProps.location.query, nextProps.model)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      location, model, heading
    } = this.props

    return (
      <div className='content Index table-header'>
        <h2 className="page-title">{heading}</h2>
        <IndexHeader model={model} params={location.query} />
        <IndexTable model={model} params={location.query} />
        <Pagination model={model} params={location.query} />
      </div>
    )
  }
}
