import React, { PropTypes, Component } from 'react'
import { Table } from 'react-bootstrap'
import InlineTableHeadCell from '../containers/InlineTableHeadCell'
import TableRow from '../../Index/containers/TableRow'

export default class InlineIndexTable extends Component {
  render() {
    const {
      fields, rows, model, params, tbodyClass, uiKey, identifier
    } = this.props

    return (
      <Table condensed striped id={identifier}>
        <thead>
          <tr>
            {fields.map((field, index) => {
              return(
                <InlineTableHeadCell
                  params={params} key={index} field={field} uiKey={uiKey}
                  identifier={identifier}
                />
              )
            })}
            <th title='actions' />
          </tr>
        </thead>
        <tbody className={tbodyClass}>
          {rows.map(row =>
            <TableRow key={row.id} row={row} fields={fields} model={model}/>
          )}
        </tbody>
      </Table>
    )
  }
}
