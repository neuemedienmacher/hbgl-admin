import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'

export default class ActionList extends Component {
  render() {
    return(
      <span className='ActionList'>
        {this.props.actions.map(this._renderLink)}
      </span>
    )
  }

  _renderLink(action, index) {
    if (action.href[0] == '/') { // is relative url
      return(
        <Link key={index} to={action.href}>
          <span className={action.icon} />
        </Link>
      )
    } else { // is fully qualified url
      return(
        <a key={index} href={action.href} target='_blank'>
          <span className={action.icon} />
        </a>
      )
    }
  }
}
