import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'

export default class AssociationItems extends React.Component {
  render() {
    const {
      modelInstance, associations
    } = this.props

    return (
      <div className="panel-group">
        <h5 className="section-title">Verknüpfte Modelle</h5>
        {associations.map(([name, className, filter, href]) =>
          this.renderAssociation(
            name, className, modelInstance[name], href, filter
          )
        )}
      </div>
    )
  }

  renderAssociation(name, className, items, href, filter){
    return(
      <div key={name} className="panel panel-default">
        <div key={`${name}-heading`} className="panel-heading show--panel">
          <h3 className="panel-title">{name}</h3>
        </div>
        {this.renderSwitch(name, className, items, href, filter)}
      </div>
    )
  }

  renderSwitch(name, className, items, href, filter){
    if(filter) {
      return(
        <div key={name} className="panel-body show--panel">
          <InlineIndex
            model={className} baseQuery={filter} identifierAddition={name}
          />
        </div>
      )
    }
    else {
      return(
        <div key={name} className="panel-body show--panel">
          {items.map(item => this.renderAssociationItem(name, item, href))}
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
