import React, { PropTypes, Component } from 'react'
import { Form, InputSet} from 'rform'
import ActionUpdateFormObject from '../forms/ActionUpdateFormObject'
import AssignmentFormObject from '../../NewAssignment/forms/AssignmentFormObject'

export default class AssignmentActions extends Component {

  render() {
    const {
      assignment, actions
    } = this.props

    return (
      <div className='content AssignmentActions'>
        {actions.map(action => {
          return this.renderForm(action)
        })}
      </div>
    )
  }

  renderForm(action) {
    const { handleResponse, afterResponse, users } = this.props

    const optionalUserSelection = action.userChoice ?
      <InputSet
        wrapperClassName='form-group' className='form-control'
        label='an' type='select' attribute='receiver_id' options={users}
      /> : null

    const optionalMessage = action.messageField ?
      <InputSet
        wrapperClassName='form-group' className='form-control'
        wrapperErrorClassName='has-error' errorClassName='help-block'
        label='Nachricht' type='textfield' attribute='message'
        placeholder='Gib eine Nachricht ein'
      /> : null

    return(
      <Form ajax requireValid seedData={action.seedData} id={action.formId}
        method='POST' action={action.href} className='form-inline'
        key={action.formId} formObjectClass={AssignmentFormObject}
        handleResponse={handleResponse} afterResponse={afterResponse}
      >
        <hr />
        {optionalMessage}
        {optionalUserSelection}
        <button type='submit' className='btn btn-warning'>
          {action.buttonText}
        </button>
      </Form>
    )
  }
}
