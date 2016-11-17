import React, { PropTypes, Component } from 'react'
import InlinePaginationCell from '../containers/InlinePaginationCell'

export default class InlinePagination extends Component {
  render() {
    const {
      pages, previousPageHref, nextPageHref, params, previousPage, nextPage,
      ui_key, identifier
    } = this.props

    return (
      <div className='pagination'>
        <ul>
          {this.renderDirectionCell('left', 'previous', previousPageHref, previousPage)}
          {pages.map(page => {
            return(
              <InlinePaginationCell
                key={page} page={page} params={params} ui_key={ui_key}
                identifier={identifier}
              />
            )
          })}
          {this.renderDirectionCell('right', 'next', nextPageHref, nextPage)}
        </ul>
      </div>
    )
  }

  renderDirectionCell(direction, className, href, onClick) {
    if (href) {
      return(
        <li className={className}>
          <a className={`fui-arrow-${direction}`} href={href} onClick={onClick} />
        </li>
      )
    }
  }
}
