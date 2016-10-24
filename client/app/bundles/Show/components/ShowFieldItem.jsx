import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'

export default class ShowFieldItem extends React.Component {
  render() {
    const {
      name, content, contentType
    } = this.props

    return (
      <div key={name} className="panel panel-default">
        <div key={`${name}-heading`} className="panel-heading show--panel">
          <h3 className="panel-title">{name}</h3>
        </div>
        <div key={name} className="panel-body show--panel">
          {this.renderContent(content, contentType)}
        </div>
      </div>
    )
  }

  renderContent(content, contentType) {
    switch(contentType) {
      case 'boolean':
        if (content) {
          return <span className='fui-check' title='Ja' />
        } else {
          return <span className='fui-cross' title='Nein' />
        }
      case 'time':
        return new Date(content).toLocaleString('de-de')
      default:
        return content
    }
  }
}
