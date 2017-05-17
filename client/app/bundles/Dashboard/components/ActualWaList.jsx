import React, { PropTypes } from 'react'
import ActualWaFormContainer from '../containers/ActualWaFormContainer'

export default class ActualWaList extends React.Component {
  render() {
    const {
      outstandingTimeAllocations
    } = this.props

    const actualWaForms = outstandingTimeAllocations.reverse().map(ta =>
      <ActualWaFormContainer timeAllocation={ta} key={ta.week_number} />
    )

    return (
      <div className="panel panel-danger">
        <div className="panel-heading">
          <h3 className="panel-title">Meta-Aufgabe: W&A-Stunden</h3>
        </div>
        <div className="panel-body">
          Bitte gib an, wie viele W&A-Stunden du tatsächlich leisten konntest:
        </div>
        <ul className='list-group'>
          {actualWaForms}
        </ul>
      </div>
    )
  }
}
