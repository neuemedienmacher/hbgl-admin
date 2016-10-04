import React, { PropTypes } from 'react'
import { Form, Input } from 'rform'
import TimeAllocationForm from '../forms/TimeAllocation'

export default class TimeAllocationRow extends React.Component {
  render() {
    const {
      user, formId, action, method, shortOrigin, originTitle, isPast, seedData,
      handleResponse
    } = this.props

    const actualInput = isPast ? (
      <td>
        <Input
          formId={formId} type='number' className='form-control' labelText=''
          model='time_allocation' attribute='actual_wa_hours'
          formObjectClass={TimeAllocationForm}
        />
      </td>
    ) : null

    return (
      <tr>
        <td>
          {user.name}
          <Form ajax
            id={formId} action={action} model='time_allocation' method={method}
            seedData={seedData}
            formObjectClass={TimeAllocationForm}
            handleResponse={handleResponse}
          >
            <Input attribute='user_id' type='hidden' />
            <Input attribute='year' type='hidden' />
            <Input attribute='week_number' type='hidden' />
          </Form>
        </td>
        <td>
          <div title={originTitle}>
            {shortOrigin}
          </div>
        </td>
        <td>
          <Input
            formId={formId} type='number' className='form-control' labelText=''
            model='time_allocation' attribute='desired_wa_hours'
            formObjectClass={TimeAllocationForm}
          />
        </td>
        {actualInput}
        <td>
          <button form={formId} type='submit' className='btn btn-default btn-sm'>
            Speichern
          </button>
        </td>
      </tr>
    )
  }
}
