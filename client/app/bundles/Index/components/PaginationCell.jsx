import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'

export default class PaginationCell extends Component {
  render() {
    const {
      page, href, activeClass
    } = this.props

    return (
      <li className={activeClass}>
        <Link to={href}>{page}</Link>
      </li>
    )
  }
}
