import React, { PropTypes, Component } from 'react'
import { Tabs, Tab } from 'react-bootstrap'

export default class ControlledTabView extends Component {

  render() {
    return (
      <Tabs
        activeKey={this.props.selectedTab} onSelect={this.props.handleSelect}
        id={this.props.uniqIdentifier} key={this.props.uniqIdentifier}
      >
       {this.props.children.map( (child, index) => {
         return(
           <Tab eventKey={index}
            title={child.props.tabTitle}
            key={this.props.uniqIdentifier + index}
           >
             {index == this.props.selectedTab ? child : null}
           </Tab>
         )
       })}
      </Tabs>
    )
  }
}
