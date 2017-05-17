import React, { PropTypes } from 'react'
import { Form, InputSet } from 'rform'
import AssignmentFormObject from '../forms/AssignmentFormObject'

export default class NewAssignmentForm extends React.Component {
  render() {
    const {
      formId, seedData, assignableModels, creatorUsers,
      creatorTeams, receiverUsers, receiverTeams, afterResponse, handleResponse
    } = this.props

    return (
      <div className='content NewAssignment'>
        <h2>Neue Zuweisung</h2>
        <Form ajax requireValid
          action='/api/v1/assignments/' method='POST'
          className='form-inline'
          id={formId} seedData={seedData}
          formObjectClass={AssignmentFormObject}
          afterResponse={afterResponse} handleResponse={handleResponse}
        >
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='für Model' type='select' attribute='assignable_type'
          options={assignableModels}
        />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          wrapperErrorClassName='has-error' errorClassName='help-block'
          label='mit ID' type='number' attribute='assignable_id'
          placeholder='ID'
        />
        <br />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='von' type='select' attribute='creator_id'
          options={creatorUsers}
        />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='im Team' type='select' attribute='creator_team_id'
          options={creatorTeams}
        />
        <br />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='für' type='select' attribute='receiver_id'
          options={receiverUsers}
        />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='im Team' type='select' attribute='receiver_team_id'
          options={receiverTeams}
        />
        <br />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          wrapperErrorClassName='has-error' errorClassName='help-block'
          label='Nachricht (optional)' type='textarea' attribute='message'
          placeholder='Nachricht'
        />
        <br />
        <button className='btn btn-default' type='submit'>
          Erstellen
        </button>
        </Form>
      </div>
    )
  }
}
