import React from 'react'
import { Form } from 'rform'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'

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
  }

  render() {
    const { data, states, stateKey, onCityChange } = this.props

    return (
      <div>
        <Form id={stateKey}>
          <FilteringSelect
            attribute='city' associatedModel='city' placeholder='Stadt…'
            onChange={onCityChange}
          />
        </Form>
        <table className='table'>
          <tbody>
            <tr>
              <th>state</th>
              <th>family</th>
              <th>refugees</th>
              <th>insgesamt</th>
            </tr>
            {states.map(this._renderStateRow.bind(this))}
            {this._renderStateRow('total')}
          </tbody>
        </table>
      </div>
    )
  }

  _renderStateRow(state) {
    const numbers = this.props.data[state] || {}

    if (numbers) {
      return(
        <tr key={state}>
          <td>{state}</td>
          <td>
            {typeof numbers.family == 'number' ? numbers.family : 'Lade…'}
          </td>
          <td>
            {typeof numbers.refugees == 'number' ? numbers.refugees : 'Lade…'}
          </td>
          <td>
            {typeof numbers.total == 'number' ? numbers.total : 'Lade…'}
          </td>
        </tr>
      )
    }
  }
}
