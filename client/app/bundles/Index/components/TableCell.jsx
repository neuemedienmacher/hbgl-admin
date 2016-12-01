import React, { PropTypes, Component } from 'react'
import isArray from 'lodash/isArray'

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
      case 'object':
        if(isArray(content)){
          return(
            <p>
              {content.map(obj => this.renderContent(obj)).join(', ')}
            </p>
          )
        } else if(content.label) {
          return content.label
        } else {
          return content
        }
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
