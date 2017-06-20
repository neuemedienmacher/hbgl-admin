import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'
import InlineIndex from '../../InlineIndex/containers/InlineIndex'

export default class AssociationItems extends React.Component {
  render() {
    const {
      model_instance, associations
    } = this.props

    return (
      <div className="panel-group">
        <h5 className="section-title">Verknüpfte Modelle</h5>
        {associations.map(([name, class_name, filter, href]) =>
          this.renderAssociation(
            name, class_name, model_instance[name], href, filter
          )
        )}
      </div>
    )
  }

  renderAssociation(name, class_name, items, href, filter){
    return(
      <div key={name} className="panel panel-default">
        <div key={`${name}-heading`} className="panel-heading show--panel">
          <h3 className="panel-title">{name}</h3>
        </div>
        {this.renderSwitch(name, class_name, items, href, filter)}
      </div>
    )
  }

  renderSwitch(name, class_name, items, href, filter){
    if(filter) {
      return(
        <div key={name} className="panel-body show--panel">
          <InlineIndex
            model={class_name} baseQuery={filter} identifier_addition={name}
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
