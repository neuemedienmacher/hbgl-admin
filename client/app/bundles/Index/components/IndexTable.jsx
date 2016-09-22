import React, { PropTypes, Component } from 'react'
import { Table } from 'react-bootstrap'
import TableHeadCell from '../containers/TableHeadCell'
import TableRow from '../containers/TableRow'

export default class IndexTable extends Component {
  render() {
    const {
      fields, rows, model, params, tbodyClass
    } = this.props

    return (
      <Table condensed striped>
        <thead>
          <tr>
            {fields.map(field => {
              return(
                <TableHeadCell
                  params={params} model={model} key={field} field={field}
                />
              )
            })}
            <th title='actions' />
          </tr>
        </thead>
        <tbody className={tbodyClass}>
          {rows.map(row =>
            <TableRow key={row.id} row={row} fields={fields} model={model} />
          )}
        </tbody>
      </Table>
    )
  }
}
