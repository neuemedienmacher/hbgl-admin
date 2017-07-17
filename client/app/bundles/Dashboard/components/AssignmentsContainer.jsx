import React, { PropTypes, Component } from 'react'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'
import ControlledSelectView from '../../ControlledSelectView/containers/ControlledSelectView'

export default class AssignmentsContainer extends Component {

  render() {
    const {
      heading, model, lockedParams, optionalParams, scope
    } = this.props

    return (
      <div className="panel-group">
        {this.teamSelectOrNull(this.props.selectableData)}
        <b>{heading}</b>
        <InlineIndex
          model={model} identifierAddition={scope}
          lockedParams={lockedParams} optionalParams={optionalParams}
        />
      </div>
    )
  }

  teamSelectOrNull(team_data) {
    if (team_data && team_data.length != 0) {
      return (
        <div className="select-set">
          <span className="select-set__label">Zeige Zuweisungen für:</span>
          <ControlledSelectView identifier={'team-assignments'}>
            {team_data}
          </ControlledSelectView>
        </div>
      )
    } else { return null }
  }
}
