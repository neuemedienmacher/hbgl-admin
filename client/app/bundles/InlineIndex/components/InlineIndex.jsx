import React, { PropTypes, Component } from 'react'
import isEqual from 'lodash/isEqual'
import InlineIndexTable from '../containers/InlineIndexTable'
import InlinePagination from '../containers/InlinePagination'

export default class InlineIndex extends Component {
  componentWillReceiveProps(nextProps) {
    // console.log('componentWillReceiveProps!')
    // console.log(this.props)
    // console.log(nextProps)
    if (isEqual(nextProps.params, this.props.params) == false ||
        this.props.model != nextProps.model) {
      this.props.loadData(nextProps.params, nextProps.model)
    }
  }

  componentDidMount() {
    // console.log('componentDidMount!')
    this.props.loadData()
  }

  render() {
    const {
      params, lockedParams, model, identifier, uiKey, count
    } = this.props

    return (
      <div className='content InlineIndex table-header'>
        <p className="index-title">Gefundene Daten: {count}</p>
        <InlineIndexTable
          model={model} params={params} identifier={identifier} uiKey={uiKey}
        />
        <InlinePagination
          params={params} identifier={identifier} uiKey={uiKey}
        />
      </div>
    )
  }
}
