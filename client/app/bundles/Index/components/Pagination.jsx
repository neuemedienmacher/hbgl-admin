import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import PaginationCell from '../containers/PaginationCell'

export default class Pagination extends Component {
  render() {
    const {
      pages, previousPageHref, nextPageHref, model, params, currentPage,
      jumpToPage, pageScope, paginationSize
    } = this.props

    return (
      <div className='pagination'>
        <ul>
          {this.renderDirectionCell('left', 'previous', previousPageHref)}
          {this.renderFirstPageLogic(currentPage, model, params, pages, paginationSize)}
          {this.renderFirstPageSeparator(currentPage, jumpToPage, paginationSize)}
          {pageScope.map(page => {
            return(
              <PaginationCell
                key={page} page={page} model={model} params={params}
              />
            )
          })}
          {this.renderLastPageSeparator(currentPage, pages, jumpToPage, paginationSize)}
          {this.renderLastPageLogic(currentPage, model, params, pages, paginationSize)}
          {this.renderDirectionCell('right', 'next', nextPageHref)}
        </ul>
      </div>
    )
  }

  renderFirstPageLogic(currentPage, model, params, pages, paginationSize) {
    if (currentPage > paginationSize + 1) {
      return(
        <PaginationCell
          key={pages[0]} page={pages[0]} model={model} params={params}
        />
      )
    }
  }

  renderFirstPageSeparator(currentPage, jumpToPage, paginationSize) {
    if (currentPage > paginationSize + 1) {
      return(
        <li>
          <span onClick={jumpToPage}>...</span>
        </li>
      )
    }
  }

  renderLastPageSeparator(currentPage, pages, jumpToPage, paginationSize) {
    if (currentPage < pages.length - paginationSize - 1) {
      return(
        <li>
          <span onClick={jumpToPage}>...</span>
        </li>
      )
    }
  }

  renderLastPageLogic(currentPage, model, params, pages, paginationSize) {
    if (currentPage < pages.length - paginationSize ) {
      return(
        <PaginationCell
          key={pages[pages.length - 1]} page={pages[pages.length - 1]}
          model={model} params={params}
        />
      )
    }
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
