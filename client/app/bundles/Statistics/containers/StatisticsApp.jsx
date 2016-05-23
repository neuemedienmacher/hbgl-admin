import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import fetchStatistics from '../actions/fetchStatistics';

import Routes from '../components/Routes'

const mapStateToProps = function(state, ownProps) {
  return {}
}

const mapDispatchToProps = function(dispatch) {
  return {
    getStatistics: () => dispatch(fetchStatistics())
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Routes)
