import React, { PropTypes } from 'react'
import { Form, InputSet } from 'rform'
import StatisticChartFormObject from '../forms/StatisticChartFormObject'

export default class StatisticChartForm extends React.Component {
  render() {
    const {
      seedData, userTeams, targetModels, targetFieldNames, targetFieldValues,
      formId, afterInputChange, afterResponse
    } = this.props

    return (
      <Form ajax requireValid
        action='/api/v1/statistic_charts/' method='POST'
        className='form-inline' formObjectClass={StatisticChartFormObject}
        id={formId} seedData={seedData} afterResponse={afterResponse}
      >
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='für' type='select' attribute='user-team-id'
          options={userTeams}
        />
        <br />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          wrapperErrorClassName='has-error' errorClassName='help-block'
          label='Titel' type='text' attribute='title' placeholder='Titel'
        />
        <br />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='vom' type='date' attribute='starts-at'
        />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='bis zum' type='date' attribute='ends-at'
        />
        <br />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          wrapperErrorClassName='has-error' errorClassName='help-block'
          label='sollen' type='number' attribute='target-count'
          placeholder='Anzahl'
        />
        <InputSet ariaLabelOnly
          wrapperClassName='form-group' className='form-control'
          type='select' attribute='klass-name' options={targetModels}
          afterChange={afterInputChange}
        />
        <br />
        <InputSet
          wrapperClassName='form-group' className='form-control'
          label='auf' type='select' attribute='target-field-name'
          options={targetFieldNames}
          afterChange={afterInputChange}
        />
        <InputSet ariaLabelOnly
          wrapperClassName='form-group' className='form-control'
          type='select' attribute='target-field-value'
          options={targetFieldValues}
        />
        gebracht werden.

        <br />
        <button className='btn btn-default' type='submit'>
          Abschicken
        </button>
      </Form>
    )
  }
}
