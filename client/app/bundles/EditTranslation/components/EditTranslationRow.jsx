import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'

export default class EditTranslationForm extends Component {
  render() {
    const { property, source } = this.props

    return (
      <tr>
        {this.renderInputOrPlainText()}
        <td>
          {source && source[property]}
        </td>
      </tr>
    )
  }

  renderInputOrPlainText() {
    const { property, length, type, content, may_edit } = this.props

    if (may_edit) {
      return(
        <td>
          <InputSet
            attribute={property} type={type} label={property} disabled='disabled'
            wrapperClassName='form-group' className='form-control'
            wrapperErrorClassName='has-error' errorClassName='help-block'
          />
          Länge: {length}
        </td>
      )
    } else {
      return(
        <td>
          {property}:
          <br />
          {content}
        </td>
      )
    }
  }
}
