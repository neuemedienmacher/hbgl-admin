import React from 'react'
import OverviewTable from '../containers/OverviewTable'

export default class OrgaOverviewPage extends React.Component {
  render() {
    return (
      <div className='jumbotron overview'>
        <h2>Organizationsübersicht</h2>
        <OverviewTable model='organization' />
      </div>
    )
  }
}
