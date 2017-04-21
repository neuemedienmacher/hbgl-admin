import React, { PropTypes, Component } from 'react'
import ControlledTabView from '../../ControlledTabView/containers/ControlledTabView'
import AssignmentsContainer from '../containers/AssignmentsContainer'

export default class OverviewPanel extends Component {
  render() {
    return (
      <ControlledTabView identifier="assignments" startIndex={1}>
        <AssignmentsContainer scope='receiver' tabTitle='Meine Aufgaben' />
        <AssignmentsContainer scope='receiver_team' tabTitle='Team Aufgaben' />
        <AssignmentsContainer scope='creator_open' tabTitle='Von mir abgeschickte Aufgaben' />
        <AssignmentsContainer scope='receiver_closed' tabTitle='Abgeschlossene Aufgaben' />
      </ControlledTabView>
    )
  }
}
