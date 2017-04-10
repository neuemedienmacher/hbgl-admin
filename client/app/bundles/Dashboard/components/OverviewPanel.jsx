import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'
import UpdateCurrentTeam from '../forms/UpdateCurrentTeam'
import AssignmentsContainer from '../containers/AssignmentsContainer'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'

export default class OverviewPanel extends Component {
  render() {
    const {
      user, selectableTeams, seedData, handleResponse
    } = this.props

    return (
      <div>
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
        <ul className="nav nav-tabs">
          <li><a data-toggle="tab" href="#menu1">Meine Aufgaben</a></li>
          <li className="active"><a data-toggle="tab" href="#menu2">Team Aufgaben</a></li>
          <li><a data-toggle="tab" href="#menu3">Von mir abgeschickte Aufgaben</a></li>
          <li><a data-toggle="tab" href="#menu4">Abgeschlossene Aufgaben</a></li>
        </ul>
        <div className="tab-content">
          <div id="menu1" className="tab-pane fade">
            <AssignmentsContainer scope={'receiver'} item_id={user.id} />
          </div>
          <div id="menu2" className="tab-pane fade in active">
            <AssignmentsContainer
              scope={'receiver_team'} item_id={user.current_team_id}
            />
          </div>
          <div id="menu3" className="tab-pane fade">
            <AssignmentsContainer scope={'creator_open'} item_id={user.id} />
          </div>
          <div id="menu4" className="tab-pane fade">
            <AssignmentsContainer scope={'receiver_closed'} item_id={user.id} />
          </div>
        </div>
      </div>
    )
  }
}
