import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import TableCell from './TableCell'

export default class TableRow extends Component {
  render() {
    const {
      fields, row, actions
    } = this.props

    return (
      <tr>
        {fields.map(field =>
          <TableCell key={field} content={row[field]} />
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
