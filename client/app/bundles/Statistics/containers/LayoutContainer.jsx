import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
import fetchStatistics from '../actions/fetchStatistics';
import fetchUsers from '../actions/fetchUsers';

import Layout from '../components/Layout'

const mapStateToProps = (state, ownProps) => ({
  hasUsers: (state.users.length > 0),
  hasStatistics: (state.statistics.length > 0),
})

const mapDispatchToProps = (dispatch) => ({
  getStatistics: () => dispatch(fetchStatistics()),
  getUsers: () => dispatch(fetchUsers())
})

export default connect(mapStateToProps, mapDispatchToProps)(Layout)
