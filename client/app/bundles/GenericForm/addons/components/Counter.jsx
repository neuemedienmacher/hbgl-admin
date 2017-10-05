import React, { PropTypes } from 'react'

export default class CounterAddon extends React.Component {
  render() {
    const { count, maximum, className } = this.props
    return(
      <div className={className}>
        {this.props.count}
        {this.renderMaximum(maximum)}
      </div>
    )
  }

  renderMaximum(maximum) {
    if(!maximum) return
    return `/${maximum}`
  }
}
