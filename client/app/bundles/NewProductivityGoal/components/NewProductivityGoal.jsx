import React, { PropTypes } from 'react'
import ProductivityGoalForm from '../containers/ProductivityGoalForm'
import PreviewBurnUpChart from '../containers/PreviewBurnUpChart'

export default class NewProductivityGoal extends React.Component {
  render() {
    return (
      <div className='content NewProductivityGoal'>
        <h2>Neues Produktivitätsziel</h2>
        <div className='chart'>
          <PreviewBurnUpChart />
        </div>
        <ProductivityGoalForm />
      </div>
    )
  }
}
