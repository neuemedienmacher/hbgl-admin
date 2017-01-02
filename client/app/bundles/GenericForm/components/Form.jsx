import React, { PropTypes } from 'react'
import { Form, InputSet } from 'rform'
import FormInputs from '../containers/FormInputs'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import CreatingSelect from '../../FilteringSelect/containers/CreatingSelect'

export default class GenericFormForm extends React.Component {
  render() {
    const {
      seedData, action, method, formId, formObjectClass,
      afterResponse, handleResponse,
    } = this.props

    return (
      <Form ajax requireValid
        method={method} className='form'
        formObjectClass={formObjectClass}
        action={action} id={formId} seedData={seedData}
        handleResponse={handleResponse} afterResponse={afterResponse}
      >
        <FormInputs formObjectClass={formObjectClass} formId={formId} />
        <button className='btn btn-default' type='submit'>
          Abschicken
        </button>
      </Form>
    )
  }
}
