import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import PaginationCell from '../containers/PaginationCell'

export default class Pagination extends Component {
  render() {
    const {
      pages, previousPageHref, nextPageHref, model, params, current_page, myClick, pageScope, paginationSize
    } = this.props

    return (
      <div className='pagination'>
        <ul>
          {this.renderDirectionCell('left', 'previous', previousPageHref)}
          {this.renderFirstPageLogic(current_page, model, params, pages, paginationSize)}
          {this.renderFirstPageSeparator(current_page, myClick, paginationSize)}
          {pageScope.map(page => {
            return(
              <PaginationCell
                key={page} page={page} model={model} params={params}
              />
            )
          })}
          {this.renderLastPageSeparator(current_page, pages, myClick, paginationSize)}
          {this.renderLastPageLogic(current_page, model, params, pages, paginationSize)}
          {this.renderDirectionCell('right', 'next', nextPageHref)}
        </ul>
      </div>
    )
  }

  renderFirstPageLogic(current_page, model, params, pages, paginationSize) {
    if (current_page > paginationSize + 1) {
      return(
        <PaginationCell
          key={pages[0]} page={pages[0]} model={model} params={params}
        />
      )
    }
  }

  renderFirstPageSeparator(current_page, myClick, paginationSize) {
    if (current_page > paginationSize + 1) {
      return(
        <li>
          <span onClick={myClick}>...</span>
        </li>
      )
    }
  }

  renderLastPageSeparator(current_page, pages, myClick, paginationSize) {
    if (current_page < pages.length - paginationSize - 1) {
      return(
        <li>
          <span onClick={myClick}>...</span>
        </li>
      )
    }
  }

  renderLastPageLogic(current_page, model, params, pages, paginationSize) {
    if (current_page < pages.length - paginationSize ) {
      return(
        <PaginationCell
          key={pages[pages.length - 1]} page={pages[pages.length - 1]} model={model} params={params}
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
