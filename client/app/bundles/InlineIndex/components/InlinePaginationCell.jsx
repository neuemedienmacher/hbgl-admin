import React, { PropTypes, Component } from 'react'

export default class InlinePaginationCell extends Component {
  render() {
    const {
      page, activeClass, onClick, href
    } = this.props

    return (
      <li className={activeClass}>
        <a href={href} onClick={onClick}>{page}</a>
      </li>
    )
  }
}
