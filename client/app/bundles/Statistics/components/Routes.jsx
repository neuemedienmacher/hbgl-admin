import React, { PropTypes } from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'
import Layout from './Layout'
import Overview from './Overview'
import Created from './Created'

export default class Statistics extends React.Component {
  static propTypes = {
    getStatistics: PropTypes.func.required
  }

  componentDidMount() {
    console.log(this.props.getStatistics)
    this.props.getStatistics()
  }

  render() {
    return (
      <Router history={browserHistory}>
        <Route path='statistics' component={Layout}>
          <IndexRoute component={Overview}/>
          <Route path='offer_created' component={Created} />
        </Route>
      </Router>
    )
  }
}
