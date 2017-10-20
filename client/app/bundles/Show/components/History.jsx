import React, { PropTypes, Component } from 'react'
import CollapsiblePanel
  from '../../CollapsiblePanel/containers/CollapsiblePanel'
import TableCell from '../../Index/containers/TableCell'

export default class History extends React.Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const { hasHistory, historyItems } = this.props
    if (!hasHistory) return null

    return(
      <CollapsiblePanel title='History' visible={false}>
        <div key={name} className="panel-body show--panel History-wrapper">
          {historyItems.map(this.renderHistoryItem.bind(this))}
        </div>
      </CollapsiblePanel>
    )
  }

  renderHistoryItem(item) {
    return(
      <div
        key={item.id}
        className="History-Item panel panel-default container-fluid"
        date-is="{item['created-at']}"
      >
        <h6 className="History-Headline">
          <span className="History-Eventtype">{item.event}</span>
          von {item.user.label} am {item.date}
        </h6>
        <table className='table History-What'>
          <thead>
            <tr>
              <td className="History_Tablehead--fieldname">
                Feld-Name
              </td>
              <td className="History_Tablehead--valuebefore">
                Wert vorher
              </td>
              <td className="History_Tablehead--valueafter">
                Wert nachher
              </td>
            </tr>
          </thead>
          <tbody>
            {item.changes.map(this.renderHistoryChange.bind(this))}
          </tbody>
        </table>
      </div>
    )
  }

  renderHistoryChange(change) {
    return(
      <tr key={change.field}>
        <td>{change.field}</td>
        <TableCell field={{field: 'before'}} row={change} />
        <TableCell field={{field: 'after'}} row={change} />
      </tr>
    )
  }
}
