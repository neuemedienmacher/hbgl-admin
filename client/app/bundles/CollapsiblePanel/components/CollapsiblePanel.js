import React, { PropTypes, Component } from 'react'

export default class CollapsiblePanel extends Component {
  render() {
    return (
      <div className="panel panel-default">
        <div className="panel-heading">
          <a data-toggle="collapse" href={`#${this.props.identifier}`}>
            <h3 className="panel-title">{this.props.title}</h3>
          </a>
        </div>
        <div id={this.props.identifier} className={this.props.className}>
          <div className="panel-body">
            {this.props.content}
          </div>
        </div>
      </div>
    )
  }
}
