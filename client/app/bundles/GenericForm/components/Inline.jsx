// DEPRECATED
import React from 'react'
import { Label, Input, Errors } from 'rform'
import Form from '../containers/Form'

export default class Inline extends React.Component {
  componentDidMount() {
    this.props.onMount()
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.value === undefined && !!nextProps.value) {
      this.props.onFirstValue(nextProps.value)
    }
  }

  render() {
    const {
      wrapperClassName,
      attribute,
      errorClassName,
      errors,
      label,
      model,
      idOrNew,
      edit,
      formId,
    } = this.props

    return (
      <div className={wrapperClassName}>
        <Label attribute={attribute} content={label} />

        <Form
          attribute={attribute}
          model={model}
          idOrNew={idOrNew}
          edit={edit}
          formId={formId}
        />

        <Errors
          className={errorClassName}
          attribute={attribute}
          errors={errors}
          formId={formId}
        />
      </div>
    )
  }
}
