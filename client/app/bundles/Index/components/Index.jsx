import React, { PropTypes, Component } from 'react'
import IndexHeader from '../containers/IndexHeader'
import IndexTable from '../containers/IndexTable'
import Pagination from '../containers/Pagination'

export default class Index extends Component {
  componentWillReceiveProps(nextProps) {
    debugger
    if (this.props.equalParams(nextProps.query, this.props.query) == false) {
      this.props.loadData(nextProps.query, nextProps.model)
    }
  }

  componentDidMount() {
    debugger
    this.props.loadData()
  }

  render() {
    const {
      location, model, heading, query, lockedParams, params, optionalParams
    } = this.props
    debugger
    return (
      <div className='content Index table-header'>
        <h2 className="page-title">{heading}</h2>
        <IndexHeader model={model} params={this.props.params} lockedParams={this.props.lockedParams} />
        <IndexTable model={model} params={query} />
        <Pagination model={model} params={query} />
      </div>
    )
  }
}
