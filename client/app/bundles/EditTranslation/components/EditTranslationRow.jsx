import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'

export default class EditTranslationForm extends Component {
  render() {
    const { property, source, length, type, content, may_edit } = this.props

    return (
      <tr>
        <td>
          <InputSet
            attribute={property} type={type} label={property} disabled={!may_edit}
            wrapperClassName='form-group' className='form-control'
            wrapperErrorClassName='has-error' errorClassName='help-block'
          />
          Länge: {length}
        </td>
        <td>
          {source && source[property]}
        </td>
      </tr>
    )
  }
}
