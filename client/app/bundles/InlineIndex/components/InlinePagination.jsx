import React, { PropTypes, Component } from 'react'
import InlinePaginationCell from '../containers/InlinePaginationCell'

export default class InlinePagination extends Component {
  render() {
    const {
      pages, previousPageHref, nextPageHref, params, previousPage, nextPage,
      uiKey, identifier, pageScope, current_page, paginationSize, jumpToPage
    } = this.props

    return (
      <div className='pagination'>
        <ul>
          {this.renderDirectionCell('left', 'previous', previousPageHref, previousPage)}
          {this.renderFirstPageLogic(current_page, params, pages, uiKey, identifier, paginationSize)}
          {this.renderFirstPageSeparator(current_page, jumpToPage, paginationSize)}
          {pageScope.map(page => {
            return(
              <InlinePaginationCell
                key={page} page={page} params={params} uiKey={uiKey}
                identifier={identifier}
              />
            )
          })}
          {this.renderLastPageSeparator(current_page, pages, jumpToPage, paginationSize)}
          {this.renderLastPageLogic(current_page, params, pages, uiKey, identifier, paginationSize)}
          {this.renderDirectionCell('right', 'next', nextPageHref, nextPage)}
        </ul>
      </div>
    )
  }

  renderFirstPageLogic(current_page, params, pages, uiKey, identifier, paginationSize) {
    if (current_page > paginationSize + 1) {
      return(
        <InlinePaginationCell
          key={pages[0]} page={pages[0]} params={params} uiKey={uiKey}
          identifier={identifier}
        />
      )
    }
  }

  renderFirstPageSeparator(current_page, jumpToPage, paginationSize) {
    if (current_page > paginationSize + 1) {
      return(
        <li>
          <span onClick={jumpToPage}>...</span>
        </li>
      )
    }
  }

  renderLastPageSeparator(current_page, pages, jumpToPage, paginationSize) {
    if (current_page < pages.length - paginationSize - 1) {
      return(
        <li>
          <span onClick={jumpToPage}>...</span>
        </li>
      )
    }
  }

  renderLastPageLogic(current_page, params, pages, uiKey, identifier, paginationSize) {
    if (current_page < pages.length - paginationSize ) {
      return(
        <InlinePaginationCell
          key={pages[pages.length - 1]} page={pages[pages.length - 1]} params={params} uiKey={uiKey}
          identifier={identifier}
        />
      )
    }
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
