import React, { PropTypes, Component } from 'react'
import { Table } from 'react-bootstrap'
import InlineTableHeadCell from '../containers/InlineTableHeadCell'
import TableRow from '../../Index/containers/TableRow'

export default class InlineIndexTable extends Component {
  render() {
    const {
      fields, rows, model, params, tbodyClass, ui_key, identifier
    } = this.props

    return (
      <Table condensed striped id={identifier}>
        <thead>
          <tr>
            {fields.map((field, index) => {
              return(
                <InlineTableHeadCell
                  params={params} model={model} key={index} field={field}
                  ui_key={ui_key} identifier={identifier}
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
