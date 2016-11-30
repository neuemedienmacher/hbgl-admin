import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'
import UpdateCurrentTeam from '../forms/UpdateCurrentTeam'
import AssignmentsContainer from '../containers/AssignmentsContainer'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'

export default class OverviewPanel extends Component {
  render() {
    const {
      user, selectableTeams, seedData, handleResponse
    } = this.props

    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <h3 className="panel-title">Willkommen, {user.name}</h3>
        </div>
        <div className="panel-body">
          <AssignmentsContainer scope={'reciever'} item_id={user.id} />
          <Form ajax
            action={`/api/v1/users/${user.id}`}
            method='PATCH'
            formObjectClass={UpdateCurrentTeam}
            seedData={seedData}
            className='form-inline'
            ref={element => this._form = element}
            handleResponse={handleResponse}
          >
            <InputSet submitOnChange
              attribute='current_team_id' type='select'
              options={selectableTeams}
              label='Ich arbeite gerade für das Team'
              className='form-group' inputClassName='form-control input-sm'
            />
          </Form>
          <AssignmentsContainer
            scope={'reciever_team'} item_id={user.current_team_id}
          />
          <AssignmentsContainer
            scope={'creator'} item_id={user.id}
          />
        </div>
      </div>
    )
  }
}
