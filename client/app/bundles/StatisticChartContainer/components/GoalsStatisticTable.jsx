import React, { PropTypes } from 'react'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'

export default class GoalsStatisticTable extends React.Component {
  render() {
    const { monthlySortedActualData, monthlySum, titleArray } = this.props

    return (
      <table className="table table-condensed table-personal-statistics">
        <thead>
          <tr>
            {titleArray.map(this.renderSingleCell.bind(this))}
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>Summe</th>
            {monthlySum.map(this.renderGoalsRow.bind(this))}
          </tr>
            {monthlySortedActualData.map(this.renderDayRow.bind(this))}
        </tbody>
      </table>
    )
  }

  renderGoalsRow(sum, index){
    return(
      <th key={index}>{sum}</th>
    )
  }

  renderDayRow(row, index){
    return(
      <tr key={index}>
        <th>{index + 1}</th>
        {row.map(this.renderSingleCell.bind(this))}
      </tr>
    )
  }

  renderSingleCell(row, index){
    return(
      <th key={index}>{row}</th>
    )
  }
}
