import React, { PropTypes, Component } from 'react'
import IndexHeader from '../containers/IndexHeader'
import IndexTable from '../containers/IndexTable'
import Pagination from '../containers/Pagination'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import isEqual from 'lodash/isEqual'

export default class Index extends Component {
  componentWillReceiveProps(nextProps) {
    console.log('Index componentWillReceiveProps this.params:', this.props.params && this.props.params['filters[assignable-id]'])
    console.log('Index componentWillReceiveProps next.params', nextProps.params && nextProps.params['filters[assignable-id]'])
    console.log('Index componentWillReceiveProps this.query', this.props.query && this.props.query['filters[assignable-id]'])
    console.log('Index componentWillReceiveProps next.query', nextProps.query && nextProps.query['filters[assignable-id]'])
    // console.log('Index componentWillReceiveProps query', newParams)
    // debugger;
    if (isEqual(nextProps.params, this.props.params) == false ||
        // isEqual(nextProps.lockedParams, this.props.lockedParams) == false || // NOTE: Hotfix!!
        isEqual(nextProps.lockedParams, this.props.lockedParams) == false || // NOTE: Hotfix!!
        isEqual(nextProps.optionalParams, this.props.optionalParams) == false || // NOTE: Hotfix!!
        nextProps.model != this.props.model
    ) {
      this.props.loadData(nextProps.query, nextProps.model)
    }
  }

  componentDidMount() {
    this.props.onMount()
  }

  render() {
    const {
      location, model, heading, query, lockedParams, optionalParams, identifier,
      uiKey, metaText, isLoading
    } = this.props

    let className = 'content Index table-header'
    if (isLoading) className += ' Index--loading'

    return (
      <div className={className}>
        <p className="page-title">{heading}</p>
        <p className="index-title">{metaText}</p>
        <IndexHeader model={model} params={query} lockedParams={lockedParams} />
        <IndexTable
          model={model} params={query} identifier={identifier} uiKey={uiKey}
        />
        <Pagination
          model={model} params={query} identifier={identifier} uiKey={uiKey}
        />
      </div>
    )
  }
}
