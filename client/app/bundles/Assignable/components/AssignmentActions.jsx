import React, { PropTypes, Component } from 'react'
import { Form, InputSet} from 'rform'
import AssignmentFormObject from '../../NewAssignment/forms/AssignmentFormObject'

export default class AssignmentActions extends Component {

  render() {
    const {
      assignment, actions
    } = this.props

    return (
      <div className='content AssignmentActions assignment-actions'>
        {actions.map(action => {
          return this.renderForm(action)
        })}
      </div>
    )
  }

  renderForm(action) {
    const { afterResponse, users } = this.props

    const optionalUserSelection = action.userChoice ?
      <div className="select-wrapper">
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='an' type='select' attribute='receiver_id' options={users}
        />
      </div> : null

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
        afterResponse={afterResponse}
      >
        {optionalMessage}
        {optionalUserSelection}
        <button type='submit' className='btn btn-default'>
          {action.buttonText}
        </button>
      </Form>
    )
  }
}
