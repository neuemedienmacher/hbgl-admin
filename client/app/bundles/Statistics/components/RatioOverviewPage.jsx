import React from 'react'

export default class OrgaOverviewPage extends React.Component {
  componentDidMount() {
    // Load sections unless they were already loaded
    if (!this.props.sections || !this.props.sections.length)
      this.props.loadSections()
  }

  componentWillReceiveProps(nextProps) {
    // Load Data when sections are loaded
    if (!this.props.sections.length && nextProps.sections.length)
      this.props.loadData(nextProps.sections)
  }

  render() {
    const {
      familyRatio, refugeesRatio, totalRatio
    } = this.props

    return (
      <div className='jumbotron overview'>
        <h2>Verhältnis Angebote pro Organisationen</h2>
        <table className='table'>
          <tbody>
            <tr>
              <th>state</th>
              <th>family</th>
              <th>refugees</th>
              <th>insgesamt</th>
            </tr>
            <tr>
              <td>all_done</td>
              <td>{familyRatio}</td>
              <td>{refugeesRatio}</td>
              <td>{totalRatio}</td>
            </tr>
          </tbody>
        </table>
        <p>
          <small>
            Erklärung:
            <br />
            (Anzahl von Angeboten die mindestens einer Orga im state all_done
              zugeordnet sind [und in clarat Welt <i>x</i> sind]) geteilt durch
            (Anzahl der Organisationen im state all_done [mit Angeboten in
              clarat Welt <i>x</i>])
          </small>
        </p>
        <p>
          <small>
            Kooperationsangebote werden somit nur einfach gezählt.
          </small>
        </p>
      </div>
    )
  }
}
