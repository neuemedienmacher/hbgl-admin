import React from "react";
import OverviewPanel from "../components/OverviewPanel";
import CollapsiblePanel from "../../CollapsiblePanel/containers/CollapsiblePanel";

export default class Dashboard extends React.Component {
  render() {
    const { user } = this.props;

    return (
      <div className="Dashboard">
        <h1 className="page-title">Dashboard</h1>
        <CollapsiblePanel
          title={`Willkommen, ${user.name}`} identifier="dashboard"
          visible={true}
        >
          <OverviewPanel params={this.props.location.query}/>
        </CollapsiblePanel>
      </div>
    );
  }
}
