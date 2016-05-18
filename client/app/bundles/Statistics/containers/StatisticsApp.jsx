import React, { PropTypes } from 'react';
import { connect } from 'react-redux';
// import { bindActionCreators } from 'redux';
// import * as helloWorldActionCreators from '../actions/helloWorldActionCreators';

import Statistics from '../components/Statistics'

const mapStateToProps = function(state, ownProps) {
  return {}
}

export default connect(mapStateToProps)(Statistics)
