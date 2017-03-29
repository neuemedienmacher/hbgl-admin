import React, { PropTypes } from 'react'
import BurnUpChart from '../../Statistics/components/BurnUpChart'

export default class BurnUpChartView extends React.Component {
  render() {
    const { data } = this.props

    return (
      <div className="chart BurnUpChartView">
        <BurnUpChart data={data} />
        <h6>Jahresziel: {this.props.lastGoalAmount}</h6>
        <table className="table table-condensed">
          <thead>
            <tr>
              <th>Datum</th>
              <th>Ist pro Tag</th>
              <th>Ist gesamt</th>
            </tr>
          </thead>
          <tbody>
            {data.actual.map(this.renderRow.bind(this))}
          </tbody>
        </table>
      </div>
    )
  }

  renderRow(point, index) {
    // console.log(point, index, this.previousPoint)
    if(index == 0) this.previousPoint = { y: 0 }
    if(this.previousPoint.y == point.y) return
    const difference = point.y - this.previousPoint.y
    this.previousPoint = point
    return(
      <tr key={index}>
        <td>{point.x}</td>
        <td>{difference}</td>
        <td>{point.y}</td>
      </tr>
    )
  }
}
