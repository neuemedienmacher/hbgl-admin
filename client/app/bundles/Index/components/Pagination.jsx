import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import PaginationCell from '../containers/PaginationCell'

export default class Pagination extends Component {
  render() {
    const {
      pages, previousPageHref, nextPageHref, model, params, current_page, myClick
    } = this.props

    return (
      <div className='pagination'>
        <ul>
          {this.renderDirectionCell('left', 'previous', previousPageHref)}
          {this.renderFirstPageLogic(current_page, model, params, pages)}
          {this.renderFirstPageSeparator(current_page, myClick)}
          {this.renderPrePageLogic(current_page, model, params, pages, 4)}
          {this.renderPrePageLogic(current_page, model, params, pages, 3)}
          {this.renderPrePageLogic(current_page, model, params, pages, 2)}
            <PaginationCell
              key={pages[current_page - 1]} page={pages[current_page - 1]} model={model} params={params}
            />
          {this.renderPostPageLogic(current_page, model, params, pages, 0)}
          {this.renderPostPageLogic(current_page, model, params, pages, 1)}
          {this.renderPostPageLogic(current_page, model, params, pages, 2)}
          {this.renderLastPageSeparator(current_page, pages, myClick)}
          {this.renderLastPageLogic(current_page, model, params, pages)}
          {this.renderDirectionCell('right', 'next', nextPageHref)}
        </ul>
      </div>
    )
  }

  renderFirstPageLogic(current_page, model, params, pages) {
    if (current_page > 4) {
      return(
        <PaginationCell
          key={pages[0]} page={pages[0]} model={model} params={params}
        />
      )
    }
  }

  renderFirstPageSeparator(current_page, myClick) {
    if (current_page > 4) {
      return(
        <li>
          <span onClick={myClick}>...</span>
        </li>
      )
    }
  }

  renderLastPageSeparator(current_page, pages, myClick) {
    if (current_page < pages.length - 4) {
      return(
        <li>
          <span onClick={myClick}>...</span>
        </li>
      )
    }
  }

  renderPrePageLogic(current_page, model, params, pages, index) {
    if (current_page > index-1) {
      return(
        <PaginationCell
          key={pages[current_page - index]} page={pages[current_page - index]} model={model} params={params}
        />
      )
    }
  }

  renderPostPageLogic(current_page, model, params, pages, index) {
    if (current_page + index < pages.length - 1 ) {
      return(
        <PaginationCell
          key={pages[current_page + index]} page={pages[current_page + index]} model={model} params={params}
        />
      )
    }
  }

  renderLastPageLogic(current_page, model, params, pages, index) {
    if (current_page < pages.length ) {
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
