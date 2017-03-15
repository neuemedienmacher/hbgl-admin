import ReactOnRails from 'react-on-rails'
import Backend from '../../Backend/startup/BackendClient'
// import Dashboard from '../../bundles/Dashboard/startup/DashboardClient'
// import StatisticsApp from '../../bundles/Statistics/startup/StatisticsAppClient'
// import NewStatisticChart from '../../bundles/NewStatisticChart/startup/NewStatisticChartClient'
// import ShowStatisticChart from '../../bundles/ShowStatisticChart/startup/ShowStatisticChartClient'
// import TimeAllocationTable from '../../bundles/TimeAllocationTable/startup/TimeAllocationTableClient'

// This is how react_on_rails can see the StatisticsApp in the browser.
ReactOnRails.register({
  Backend,
  // StatisticsApp, NewStatisticChart, ShowStatisticChart, TimeAllocationTable,
  // Dashboard,
})
