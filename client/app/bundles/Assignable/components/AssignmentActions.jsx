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
    const {
      afterResponse, users, teams, topics, assignment, assignableChanged
    } = this.props

    const optionalUserAndTeamSelection = action.userAndTeamChoice ?
      <span>
        <div className="select-wrapper">
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='an' type='select' attribute='receiver-id' options={users}
          />
        </div>
        <div className="select-wrapper">
          <InputSet
            wrapperClassName='form-group' className='form-control' label='Team'
            type='select' attribute='receiver-team-id' options={teams}
          />
        </div>
      </span> : null

    const optionalTopicSelection = action.topicChoice ?
      <div className="select-wrapper">
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='zum Thema' type='select' attribute='topic' options={topics}
          selected={assignment.topic}
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
        {optionalUserAndTeamSelection}
        {optionalTopicSelection}
        <button type='submit' className='btn btn-default'
          disabled={assignableChanged}>
          {action.buttonText}
        </button>
      </Form>
    )
  }
}
