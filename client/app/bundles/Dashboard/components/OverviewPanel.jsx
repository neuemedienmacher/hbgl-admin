import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'
import UpdateCurrentTeam from '../forms/UpdateCurrentTeam'

export default class OverviewPanel extends Component {
  render() {
    const {
      user, selectableTeams, seedData,
    } = this.props

    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Willkommen, {user.name}</h3>
        </div>
        <div className="panel-body">
          Du hast aktuell 0 zugewiesene Aufgaben.
          <hr />
          <Form ajax
            action={`/api/v1/users/${user.id}`}
            method='PATCH'
            formObjectClass={UpdateCurrentTeam}
            seedData={seedData}
            className='form-inline'
            ref={element => this._form = element}
          >
            <InputSet submitOnChange
              attribute='current_team_id' type='select'
              options={selectableTeams}
              label='Ich arbeite gerade für das Team'
              className='form-group' inputClassName='form-control input-sm'
            />
          </Form>
        </div>
      </div>
    )
  }
}
