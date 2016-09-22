import React, { PropTypes } from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'
import Layout from './Layout'
import Overview from './Overview'
import OfferCreatedPage from './OfferCreatedPage'
import OfferApprovedPage from './OfferApprovedPage'
import OrgaCreatedPage from './OrgaCreatedPage'
import OrgaApprovedPage from './OrgaApprovedPage'
import ProductivityGoalPage from './ProductivityGoalPage'

export default class Statistics extends React.Component {
  render() {
    return (
      <Router history={browserHistory}>
        <Route path='statistics' component={Layout}>
          <IndexRoute component={Overview}/>
          <Route path='offer_created' component={OfferCreatedPage} />
          <Route path='offer_approved' component={OfferApprovedPage} />
          <Route path='organization_created' component={OrgaCreatedPage} />
          <Route path='organization_approved' component={OrgaApprovedPage} />
          <Route path='productivity_goals' component={ProductivityGoalPage} />
        </Route>
      </Router>
    )
  }
}
