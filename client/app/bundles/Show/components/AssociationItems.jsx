import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import isArray from 'lodash/isArray'

export default class AssociationItems extends React.Component {
  render() {
    const {
      model_instance, associations
    } = this.props

    return (
      <div className="panel-group">
        <h5>Verknüpfte Modelle</h5>
        {associations.map(([assoc_name, assoc_columns, href]) =>
          this.renderAssociation(assoc_name, model_instance[assoc_name], href)
        )}
      </div>
    )
  }

  renderAssociation(name, content, href){
    return(
      <div key={name} className="panel panel-default">
        <div key={`${name}-heading`} className="panel-heading show--panel">
          <h3 className="panel-title">{name}</h3>
        </div>
        <div key={name} className="panel-body show--panel">
          {content.map(item => this.renderAssociationItem(name, item, href))}
        </div>
      </div>
    )
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
    else{
      return(
        <span key={`${name}.${item['label']}`}>
          {item['label']}{', '}
        </span>
      )
    }
  }
}
