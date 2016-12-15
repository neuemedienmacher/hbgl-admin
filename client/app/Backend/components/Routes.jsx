import React, { PropTypes } from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'

import Layout from './Layout'
import Index from '../../bundles/Index/containers/Index'
import Show from '../../bundles/Show/containers/Show'
import NewEdit from '../../bundles/GenericForm/containers/NewEdit'
import Export from '../../bundles/Export/containers/Export'
import DashboardContainer
  from '../../bundles/Dashboard/containers/DashboardContainer'
import ShowProductivityGoalContainer
  from '../../bundles/ShowProductivityGoal/containers/ShowProductivityGoalContainer'
import NewProductivityGoal
  from '../../bundles/NewProductivityGoal/components/NewProductivityGoal'
import NewAssignment
  from '../../bundles/NewAssignment/containers/NewAssignmentForm'
import NewOrganization
  from '../../bundles/NewOrganization/containers/NewOrganizationForm'
import TimeAllocationTableContainer
  from '../../bundles/TimeAllocationTable/containers/TimeAllocationTableContainer'
import StatisticsLayout from '../../bundles/Statistics/components/StatisticsLayout'
import Overview from '../../bundles/Statistics/components/Overview'
import OfferOverviewPage from '../../bundles/Statistics/components/OfferOverviewPage'
import OrgaOverviewPage from '../../bundles/Statistics/components/OrgaOverviewPage'
import RatioOverviewPage from '../../bundles/Statistics/containers/RatioOverviewPage'
import OfferCreatedPage from '../../bundles/Statistics/components/OfferCreatedPage'
import OfferApprovedPage from '../../bundles/Statistics/components/OfferApprovedPage'
import OrgaCreatedPage from '../../bundles/Statistics/components/OrgaCreatedPage'
import OrgaApprovedPage from '../../bundles/Statistics/components/OrgaApprovedPage'
import ProductivityGoalPage from '../../bundles/Statistics/components/ProductivityGoalPage'
import EditTranslation from
  '../../bundles/EditTranslation/containers/EditTranslation'

export default class Routes extends React.Component {
  render() {
    return (
      <Router history={browserHistory}>
        <Route path='/' component={Layout}>
          <IndexRoute component={DashboardContainer}/>

          <Route path='organizations'>
            <IndexRoute component={Index}/>
            <Route path='new' component={NewOrganization} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='divisions'>
            <IndexRoute component={Index}/>
            <Route path='new' component={NewEdit} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='offers'>
            <IndexRoute component={Index}/>
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='productivity_goals'>
            <IndexRoute component={Index}/>
            <Route path='new' component={NewProductivityGoal} />
            <Route path=':id' component={ShowProductivityGoalContainer} />
          </Route>

          <Route path='time_allocations'>
            <IndexRoute component={TimeAllocationTableContainer}/>
            <Route
              path=':year/:week_number'
              component={TimeAllocationTableContainer}
            />
          </Route>

          <Route path='statistics' component={StatisticsLayout}>
            <IndexRoute component={Overview}/>
            <Route path='offer_overview' component={OfferOverviewPage} />
            <Route path='organization_overview' component={OrgaOverviewPage} />
            <Route path='ratio_overview' component={RatioOverviewPage} />
            {/*
            <Route path='offer_created' component={OfferCreatedPage} />
            <Route path='offer_approved' component={OfferApprovedPage} />
            <Route path='organization_created' component={OrgaCreatedPage} />
            <Route path='organization_approved' component={OrgaApprovedPage} />
            */}
          </Route>

          <Route path='offer_translations'>
            <IndexRoute component={Index} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={EditTranslation} model='offer' />
          </Route>

          <Route path='organization_translations'>
            <IndexRoute component={Index} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={EditTranslation} model='organization' />
          </Route>

          <Route path='user_teams'>
            <IndexRoute component={Index} />
            <Route path='new' component={NewEdit} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={NewEdit} />
          </Route>

          <Route path='users'>
            <IndexRoute component={Index} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='assignments'>
            <IndexRoute component={Index} />
            <Route path='new' component={NewAssignment} />
            <Route path=':id' component={Show} />
          </Route>
        </Route>
      </Router>
    )
  }
}
