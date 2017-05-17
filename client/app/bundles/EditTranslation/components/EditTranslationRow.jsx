import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'

export default class EditTranslationForm extends Component {
  render() {
    const { property, source } = this.props

    return (
      <tr>
        <td>
          {this.renderTextOrForm()}
        </td>
        <td>
          {source && source[property]}
        </td>
      </tr>
    )
  }

  renderTextOrForm(){
    const { property, length, source, content, type, mayEdit } = this.props

    if (mayEdit && (source && source[property] || content)) {
      return (
        <div>
          <InputSet
            attribute={property} type={type} label={property}
            wrapperClassName='form-group' className='form-control'
            wrapperErrorClassName='has-error' errorClassName='help-block'
          />
          Länge: {length}
        </div>
      )
    }
    else {
      return (
        <div>
          {content}
        </div>
      )
    }
  }
}
