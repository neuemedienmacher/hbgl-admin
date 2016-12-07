import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'

export default class EditTranslationForm extends Component {
  render() {
    const { property, length, source, may_edit } = this.props

    return (
      <tr>
        <td>
          {this.renderTextOrForm()}
          Länge: {length}
        </td>
        <td>
          {source && source[property]}
        </td>
      </tr>
    )
  }

  renderTextOrForm(){
    const { property, content, type, may_edit } = this.props

    if (may_edit) {
      return (
        <InputSet
          attribute={property} type={type} label={property}
          wrapperClassName='form-group' className='form-control'
          wrapperErrorClassName='has-error' errorClassName='help-block'
        />
      )
    }
    else {
      return <div>{content}</div>
    }
  }
}
