import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import TableCell from '../containers/TableCell'

export default class TableRow extends Component {
  render() {
    const {
      fields, row, actions, content
    } = this.props

    return (
      <tr>
        {fields.map((field, index) =>
          <TableCell key={index} row={row} field={field} />
        )}
        <td>
          {actions.map(action => {
            return(
              <Link key={action.href} to={action.href}>
                <span className={action.icon} />
              </Link>
            )
          })}
        </td>
      </tr>
    )
  }
}
