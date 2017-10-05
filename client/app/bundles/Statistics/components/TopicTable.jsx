import React from 'react'
import { Form } from 'rform'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'

export default class TopicTable extends React.Component {
  componentDidMount() {
    // Load teams unless they were already loaded
    if(!this.props.teams || !this.props.teams.length ||
       !this.props[this.props.columnName] ||
       !this.props[this.props.columnName].length)
      this.props.loadColumns(this.props.columnName)
  }

  componentWillReceiveProps(nextProps) {
    // Load Data when teams are loaded
    if (nextProps.teams.length && nextProps.columnElements.length &&
        (!this.props.teams.length || !this.props.columnElements.length))
      this.props.loadData(nextProps.columnName,
                          nextProps.teams,
                          nextProps.columnElements)
  }

  render() {
    const {
      data, teams, teamKey, onCityChange, columnElements, columnName
    } = this.props

    return (
      <div>
        <Form id={teamKey}>
          <FilteringSelect
            attribute='city' resource='city' placeholder='Stadt…'
            onChange={onCityChange}
          />
        </Form>
        <table className='table'>
          <tbody>
            <tr>
              <th>team</th>
              {columnElements.map(topic => this.renderColumns(topic))}
              <th>total</th>
            </tr>
            {teams.map(this._renderStateRow.bind(this))}
            {this._renderStateRow('total')}
          </tbody>
        </table>
      </div>
    )
  }

  renderColumns(topic) {
    return( <th key={topic}> {topic} </th> )
  }

  renderCell(topic, numbers) {
    return(
      <td key={topic} >
        {typeof numbers[topic] == 'number' ? numbers[topic] : 'Lade…'}
      </td>
    )
  }

  _renderStateRow(team) {
    const numbers = this.props.data[team] || {}

    if (numbers) {
      return(
        <tr key={team}>
          <td>{team}</td>
          {this.props.columnElements.map(t => this.renderCell(t, numbers))}
          <td>
            {typeof numbers.total == 'number' ? numbers.total : 'Lade…'}
          </td>
        </tr>
      )
    }
  }
}
