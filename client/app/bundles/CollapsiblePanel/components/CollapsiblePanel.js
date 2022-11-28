import React, { PropTypes, Component } from 'react'
import { Panel } from 'react-bootstrap'

export default class CollapsiblePanel extends Component {
  constructor(props){
    super(props)
  }
  render() {
    return (
      <div className='ca-panel'>
        <Panel
          collapsible
          expanded={this.props.open}
        >
          <Panel.Heading>{this.renderCollapsibleHeader(
            this.props.title,
            this.props.open,
            this.props.onClick
          )}</Panel.Heading>
          {this.props.open && this.props.children && (<Panel.Body>
            {this.props.children ? this.props.children : null}
           </Panel.Body>)}
        </Panel>
      </div>
    )
  }

  renderCollapsibleHeader(title, open, onClick) {
    return (
      <div
        onClick={onClick}
        style={{ cursor: 'pointer' }}
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
