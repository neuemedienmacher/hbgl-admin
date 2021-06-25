import React, { Component } from "react";
import isArray from "lodash/isArray";

export default class TableCell extends Component {
  render() {
    const {
      content, contentType
    } = this.props;

    return (
      <td>
        {this.renderContent(content, contentType)}
      </td>
    );
  }

  renderContent(content, contentType) {
    if (content == undefined) {
      return <span className="fa fa-hand-spock-o" title="null" />;
    }
    switch (contentType) {
      case "object":
        if (isArray(content)) {
          return (
            <p>
              {content.map(obj =>
                this.renderContent(obj, obj.type)).join(", ")}
            </p>
          );
        } if (content.label) {
          return content.label;
        }
        return content;

      case "boolean":
        if (content) {
          return <span className="fa fa-check" title="Ja" />;
        }
        return <span className="fa fa-times" title="Nein" />;

      case "string":
        return content.substr(0, 100) + (content.length > 100 ? " (...)" : "");
      case "time":
        return new Date(content).toLocaleString("de-de");
      default:
        return content;
    }

  }
}
