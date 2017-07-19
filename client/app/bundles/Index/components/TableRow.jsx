import React, { PropTypes, Component } from 'react'
import TableCell from '../containers/TableCell'
import ActionList from '../../ActionList/containers/ActionList'

export default class TableRow extends Component {
  render() {
    const { fields, row, content, model } = this.props

    return(
      <tr>
        {fields.map((field, index) =>
          <TableCell key={index} row={row} field={field} />
        )}
        <td>
          <ActionList model={model} id={row.id} />
        </td>
      </tr>
    )
  }
}
