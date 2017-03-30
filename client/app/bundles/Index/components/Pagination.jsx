import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import { Pagination, Button } from 'react-bootstrap'

export default class PaginationComponent extends Component {
  render() {
    const {
      totalPages, currentPage, onPageSelect, jumpToPage
    } = this.props

    return (
      <div>
        <Pagination
          prev next first last ellipsis boundaryLinks
          items={totalPages}
          maxButtons={5}
          activePage={currentPage}
          onSelect={onPageSelect}
        />
        <Button onClick={jumpToPage} style={{marginLeft: '5px'}}>
          Zu Seite…
        </Button>
      </div>
    )
  }
}
