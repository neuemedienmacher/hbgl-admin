import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import PaginationCell from '../containers/PaginationCell'

export default class Pagination extends Component {
  render() {
    const {
      pages, previousPageHref, nextPageHref, model, params
    } = this.props

    return (
      <div className='pagination'>
        <ul>
          {this.renderDirectionCell('left', 'previous', previousPageHref)}
          {pages.map(page => {
            return(
              <PaginationCell
                key={page} page={page} model={model} params={params}
              />
            )
          })}
          {this.renderDirectionCell('right', 'next', nextPageHref)}
        </ul>
      </div>
    )
  }

  renderDirectionCell(direction, className, href) {
    if (href) {
      return(
        <li className={className}>
          <Link className={`fui-arrow-${direction}`} to={href} />
        </li>
      )
    }
  }
}
