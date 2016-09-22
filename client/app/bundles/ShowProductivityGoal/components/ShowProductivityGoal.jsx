import React, { PropTypes } from 'react'
import BurnUpChartContainer from '../containers/BurnUpChartContainer'

export default class ShowProductivityGoal extends React.Component {
  render() {
    return (
      <div className="content ShowProductivityGoal">
        <h2>Ziel: {this.props.productivity_goal.title}</h2>
        <hr />
        <div className="chart">
          <BurnUpChartContainer
            productivity_goal={this.props.productivity_goal}
          />
        </div>
      </div>
    )
  }
}
