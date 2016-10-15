import React, { PropTypes, Component } from 'react'
import InlineIndexTable from '../containers/InlineIndexTable'
import InlinePagination from '../containers/InlinePagination'

export default class InlineIndex extends Component {
  componentWillReceiveProps(nextProps) {
    if (this.props.equalParams(nextProps.params, this.props.params) == false) {
      // console.log('InlineIndex: NEW DATA LOAD')
      this.props.loadData(nextProps.params, nextProps.model)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      params, model, identifier, ui_key
    } = this.props

    return (
      <div className='content InlineIndex'>
        <InlineIndexTable
          model={model} params={params} identifier={identifier} ui_key={ui_key}
        />
        <InlinePagination
          params={params} identifier={identifier} ui_key={ui_key}
        />
      </div>
    )
  }
}
