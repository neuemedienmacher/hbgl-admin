import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import CurrentAssignment from '../components/CurrentAssignment'
import ControlledTabView from '../../ControlledTabView/containers/ControlledTabView'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'

export default class AssignableContainer extends Component {
  static childContextTypes = {
    disableUiElements: PropTypes.bool
  }

  getChildContext() {
    return {
      disableUiElements: this.props.disableUiElements
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.model != this.props.model || nextProps.id != this.props.id) {
      this.props.loadData(nextProps.model, nextProps.id)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const { model, heading, disableUiElements, assignment, involvedEntities,
            loaded, assignableDataLoad } = this.props
    const panelClass = disableUiElements ? 'panel panel-warning' : 'panel panel-info'

    return (
      <div className='content Assignment'>
        <div key={model} className={panelClass}>
          <div key={`${model}-heading`} className="panel-heading show--panel">
            {heading}
          </div>
          <div key={name} className="panel-body show--panel">
            <ControlledTabView key={`${model}-current-assignment`}
              identifier={`${model}-assignment-container`}
            >
              <CurrentAssignment tabTitle='Aktuelle Zuweisung'
                assignment={assignment} involvedEntities={involvedEntities}
                loaded={loaded} assignableDataLoad={assignableDataLoad}
              />
              <InlineIndex
                model={model} tabTitle='Zuweisungsverlauf'
                identifierAddition={
                  `${assignment['assignable-id']}-assignment-history`
                }
                lockedParams={{
                  'filters[assignable-id]': assignment['assignable-id'],
                  'filters[assignable-type]': assignment['assignable-type'],
                  'per_page': 5,
                }} optionalParams={{
                  'sort_field': 'created-at', 'sort_direction': 'DESC'
                }}
              />
            </ControlledTabView>
          </div>
        </div>
        {this.props.children}
      </div>
    )
  }
}
