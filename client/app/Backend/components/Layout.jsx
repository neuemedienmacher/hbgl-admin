import React, { Component } from 'react';
import PropTypes from 'prop-types';
import TopNav from '../containers/TopNav';
import FlashMessageList from '../containers/FlashMessageList';

import './layout.css';

const DEFAULT_ROUTE = '/dashboard';

export default class Layout extends Component {
  componentDidUpdate() {
    document.title = this.props.location.pathname.substr(1);
  }

  render() {
    return (
      <div className="Layout claradmin">
        <TopNav />
          <div className="content-wrapper">
            <div className="container-fluid">
              <div className="row">
                <FlashMessageList />
                {this.props.children}
              </div>
            </div>
          </div>
      </div>
    );
  }
}

Layout.propTypes = {
  location: PropTypes.shape({
    pathname: PropTypes.string,
  }),
};

Layout.defaultProps = {
  location: {
    pathname: DEFAULT_ROUTE,
  },
};
