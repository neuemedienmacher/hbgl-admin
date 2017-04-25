import React, { PropTypes, Component } from 'react'
import { Panel } from 'react-bootstrap'

export default class CollapsiblePanel extends Component {
  render() {
    return (
      <div className='ca-panel'>
        <Panel collapsible expanded={this.props.open}
          header={this.renderCollapsibleHeader(
            this.props.title, this.props.open, this.props.onClick
          )}
        >
          {this.props.open && this.props.children ? this.props.children : null}
        </Panel>
      </div>
    )
  }

  renderCollapsibleHeader(title, open, onClick) {
    return (
      <div onClick={onClick} style={{cursor: 'pointer'}}
        className='CustomCollapsiblePanelHeader'
      >
        {title}
        {this.renderCollapsibleSymbol(open)}
      </div>
    )
  }

  renderCollapsibleSymbol(open) {
    if (open) {
      return <i className='fa fa-angle-up collapsible-arrow' />
    } else {
      return <i className='fa fa-angle-down collapsible-arrow' />
    }
  }
}
