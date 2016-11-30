import React from 'react'
import toPairs from 'lodash/toPairs'

export default class OverviewTable extends React.Component {
  componentDidMount() {
    // Load states unless they were already loaded
    if(!this.props.states || !this.props.states.length)
      this.props.loadStates()
  }

  componentWillReceiveProps(nextProps) {
    // Load Data when states are loaded
    if (!this.props.states.length && nextProps.states.length)
      this.props.loadData(nextProps.states)

    // Calculate totals when all data has been loaded
    if (!this.props.allDataLoaded && nextProps.allDataLoaded)
      this.props.calculateTotals(nextProps.data)
  }

  render() {
    const { data } = this.props

    return (
      <table className='table'>
        <tbody>
          <tr>
            <th>state</th>
            <th># in family</th>
            <th># in refugees</th>
            <th>zusammen</th>
          </tr>
          {toPairs(data).map(([state, numbers]) => {
            return(
              <tr key={state}>
                <td>{state}</td>
                <td>{numbers.family}</td>
                <td>{numbers.refugees}</td>
                <td>{numbers.total}</td>
              </tr>
            )
          })}
        </tbody>
      </table>
    )
  }
}
