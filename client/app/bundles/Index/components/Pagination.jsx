import React, { Component } from "react";
import { Pagination, Button } from "react-bootstrap";

export default class PaginationComponent extends Component {
  render() {
    const {
      totalPages, currentPage, onPageSelect, jumpToPage
    } = this.props;

    return (
      <div className="table-pagination">
        <Pagination
          prev={true} next={true} first={true} last={true} ellipsis={true} boundaryLinks={true}
          items={totalPages}
          maxButtons={5}
          activePage={currentPage}
          onSelect={onPageSelect}
        />
        <Button onClick={jumpToPage} style={{ marginLeft: "5px" }}>
          Zu Seite…
        </Button>
      </div>
    );
  }
}
