import React, { PropTypes, Component } from 'react'

export default class TableCell extends Component {
  render() {
    const {
      content, contentType
    } = this.props

    return (
      <td>
        {this.renderContent(content, contentType)}
      </td>
    )
  }

  renderContent(content, contentType) {
    switch(contentType) {
      case 'boolean':
        if (content) {
          return <span className='fui-check' title='Ja' />
        } else {
          return <span className='fui-cross' title='Nein' />
        }
      case 'string':
        return content.substr(0, 100)
      case 'time':
        return new Date(content).toLocaleString('de-de')
      default:
        return content
    }
  }
}
