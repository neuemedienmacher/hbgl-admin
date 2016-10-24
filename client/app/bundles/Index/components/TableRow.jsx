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
            return action.visible ? this.reactOrNormalLink(action) : null
          })}
        </td>
      </tr>
    )
  }

  reactOrNormalLink(action) {
    if(action.reactLink) {
      return(
        <Link key={action.href} to={action.href}>
          <span className={action.icon} />
        </Link>
      )
    }else {
      return(
        <a key={action.href} href={action.href}>
          <span className={action.icon} />
        </a>
      )
    }
  }
}
