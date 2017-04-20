import React, { PropTypes, Component } from 'react'
import InlineIndexTable from '../containers/InlineIndexTable'
import InlinePagination from '../containers/InlinePagination'
import InlineIndexHeader from '../containers/InlineIndexHeader'

export default class InlineIndex extends Component {
  componentWillReceiveProps(nextProps) {
    if (this.props.equalParams(nextProps.params, this.props.params) == false) {
      this.props.loadData(nextProps.params, nextProps.model)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      params, lockedParams, model, identifier, uiKey, count
    } = this.props

    return (
      <div className='content InlineIndex table-header'>
        <InlineIndexHeader
          model={model} params={params} identifier={identifier} uiKey={uiKey}
          lockedParams={lockedParams}
        />
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
