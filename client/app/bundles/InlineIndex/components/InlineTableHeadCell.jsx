import React, { PropTypes, Component } from 'react'

export default class InlineTableHeadCell extends Component {
  render() {
    const {
      onClick, href
    } = this.props

    return (
      <th>
        <a href={href} onClick={onClick}>
          {this.renderFieldName()}
          {this.renderSortSymbol()}
        </a>
      </th>
    )
  }

  renderSortSymbol() {
    if (this.props.isCurrentSortField) {
      if (this.props.currentDirection == 'ASC') {
        return <i className='fui-triangle-up-small' />
      } else {
        return <i className='fui-triangle-down-small' />
      }
    }
  }

  renderFieldName() {
    if (this.props.isCurrentSortField) {
      return <u>{this.props.displayName}</u>
    } else {
      return this.props.displayName
    }
  }
}
