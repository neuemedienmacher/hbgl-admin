import React, { PropTypes, Component } from 'react'

export default class TableCell extends Component {
  render() {
    const {
      content
    } = this.props

    return (
      <td>
        {this.renderContent(content)}
      </td>
    )
  }

  renderContent(content) {
    switch(typeof content) {
      case 'boolean':
        if (content) {
          return <span className='fui-check' title='Ja' />
        } else {
          return <span className='fui-cross' title='Nein' />
        }
      case 'string':
        return content.substr(0, 100)
      default:
        return content
    }
  }
}
