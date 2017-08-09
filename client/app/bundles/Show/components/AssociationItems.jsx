import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'
import CollapsiblePanel from '../../CollapsiblePanel/containers/CollapsiblePanel'

export default class AssociationItems extends React.Component {
  render() {
    const { associations, model, modelInstance } = this.props

    return (
      <div className="panel-group">
        <h5 className="section-title">Verknüpfte Modelle</h5>
        {associations.map(([name, className, filter, href, items]) =>
          this.renderSwitch(
            name, className, items, href, filter, model, modelInstance
          )
        )}
      </div>
    )
  }

  renderSwitch(name, className, items, href, filter, model, modelInstance){
    if(filter) {
      return(
        <CollapsiblePanel
          title={name} identifier={`${model}-${modelInstance.id}-${name}`}
          key={`${model}-${modelInstance.id}-${name}`} visible={false}
        >
          <div key={name} className="panel-body show--panel">
            <InlineIndex
              model={className} lockedParams={filter}
              identifierAddition={`${model}-${modelInstance.id}-${name}`}
            />
          </div>
        </CollapsiblePanel>
      )
    }
    else {
      return(
        <div key={name} className="panel panel-default">
          <div key={`${name}-heading`} className="panel-heading show--panel">
            <h3 className="panel-title">{name}</h3>
          </div>
            <div key={`${name}-item`} className="panel-body show--panel">
              {items.map(item => this.renderAssociationItem(name, item, href))}
            </div>
        </div>
      )
    }
  }

  renderAssociationItem(name, item, href){
    // render Link if there is a show action and an ID for this association
    if(href && item['id']){
      return(
        <span key={href + item['id']}>
          <Link key={href + item['id']} to={href + item['id']}>
            {item['label']}
          </Link>{', '}
        </span>
      )
    }
    // otherwise just render the label as text
    else {
      return(
        <span key={`${name}.${item['label']}`}>
          {item['label']}{', '}
        </span>
      )
    }
  }
}
