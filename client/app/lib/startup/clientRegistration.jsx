import ReactOnRails from 'react-on-rails'
import Backend from '../../Backend/startup/BackendClient'
// import Dashboard from '../../bundles/Dashboard/startup/DashboardClient'
// import StatisticsApp from '../../bundles/Statistics/startup/StatisticsAppClient'
// import NewProductivityGoal from '../../bundles/NewProductivityGoal/startup/NewProductivityGoalClient'
// import ShowProductivityGoal from '../../bundles/ShowProductivityGoal/startup/ShowProductivityGoalClient'
// import TimeAllocationTable from '../../bundles/TimeAllocationTable/startup/TimeAllocationTableClient'

// This is how react_on_rails can see the StatisticsApp in the browser.
ReactOnRails.register({
  Backend,
  // StatisticsApp, NewProductivityGoal, ShowProductivityGoal, TimeAllocationTable,
  // Dashboard,
})
