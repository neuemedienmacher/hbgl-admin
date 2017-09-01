import React, { PropTypes } from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'

import Layout from './Layout'
import Index from '../../bundles/Index/containers/Index'
import Show from '../../bundles/Show/containers/Show'
import Delete from '../../bundles/Delete/containers/Delete'
import GenericForm from '../../bundles/GenericForm/containers/Standalone'
import Export from '../../bundles/Export/containers/Export'
import DashboardContainer
  from '../../bundles/Dashboard/containers/DashboardContainer'
import ShowStatisticChart
  from '../../bundles/StatisticChartContainer/containers/PersonalStatisticChartContainer'
import NewStatisticChart
  from '../../bundles/NewStatisticChart/components/NewStatisticChart'
import NewAssignment
  from '../../bundles/NewAssignment/containers/NewAssignmentForm'
// import NewOrganization
//   from '../../bundles/NewOrganization/containers/NewOrganizationForm'
import TimeAllocationTableContainer
  from '../../bundles/TimeAllocationTable/containers/TimeAllocationTableContainer'
import StatisticsLayout
  from '../../bundles/Statistics/components/StatisticsLayout'
import Overview from '../../bundles/Statistics/components/Overview'
import OfferOverviewPage
  from '../../bundles/Statistics/components/OfferOverviewPage'
import OrgaOverviewPage
  from '../../bundles/Statistics/components/OrgaOverviewPage'
import OrgaOfferCitiesOverview
  from '../../bundles/Statistics/components/OrgaOfferCitiesOverviewPage'
import RatioOverviewPage
  from '../../bundles/Statistics/containers/RatioOverviewPage'
// import OfferCreatedPage from '../../bundles/Statistics/components/OfferCreatedPage'
// import OfferApprovedPage from '../../bundles/Statistics/components/OfferApprovedPage'
// import OrgaCreatedPage from '../../bundles/Statistics/components/OrgaCreatedPage'
// import OrgaApprovedPage from '../../bundles/Statistics/components/OrgaApprovedPage'
// import StatisticChartPage from '../../bundles/Statistics/components/StatisticChartPage'
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
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='divisions'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
            <Route path=':id/delete' component={Delete} />
          </Route>

          <Route path='offers'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='split-bases'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='subscriptions'>
            <IndexRoute component={Index}/>
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='update-requests'>
            <IndexRoute component={Index}/>
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='locations'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='cities'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='openings'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='tags'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='definitions'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='federal-states'>
            <IndexRoute component={Index}/>
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='contact-people'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='emails'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='solution-categories'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='websites'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          /*
          <Route path='statistic_charts'>
            <IndexRoute component={Index}/>
            <Route path='new' component={NewStatisticChart} />
            <Route path=':id' component={ShowStatisticChart} />
          </Route>

          <Route path='time_allocations'>
            <IndexRoute component={TimeAllocationTableContainer}/>
            <Route
              path=':year/:week_number'
              component={TimeAllocationTableContainer}
            />
          </Route>
          */

          <Route path='statistics' component={StatisticsLayout}>
            <IndexRoute component={Overview}/>
            <Route path='offer-overview' component={OfferOverviewPage} />
            <Route path='organization-overview' component={OrgaOverviewPage} />
            <Route path='orga-offer-cities-overview'
              component={OrgaOfferCitiesOverview}
            />
            <Route path='ratio-overview' component={RatioOverviewPage} />
            {/*
            <Route path='offer-created' component={OfferCreatedPage} />
            <Route path='offer-approved' component={OfferApprovedPage} />
            <Route path='organization-created' component={OrgaCreatedPage} />
            <Route path='organization-approved' component={OrgaApprovedPage} />
            */}
          </Route>

          <Route path='offer-translations'>
            <IndexRoute component={Index} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={EditTranslation} model='offer' />
          </Route>

          <Route path='organization-translations'>
            <IndexRoute component={Index} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={EditTranslation}
              model='organization'
            />
          </Route>

          <Route path='user-teams'>
            <IndexRoute component={Index} />
            <Route path='new' component={GenericForm} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
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

          <Route path='areas'>
            <IndexRoute component={Index}/>
            <Route path=':id' component={Show} />
          </Route>

          <Route path='sections'>
            <IndexRoute component={Index}/>
            <Route path=':id' component={Show} />
          </Route>
        </Route>
      </Router>
    )
  }
}
