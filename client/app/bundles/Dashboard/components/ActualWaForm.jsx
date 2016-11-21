import React, { PropTypes } from 'react'
import { Form, InputSet, Button } from 'rform'
import ActualWaFormObject from '../forms/ActualWaForm'

export default class ActualWaForm extends React.Component {
  static propTypes = {
    time_allocation: PropTypes.object.isRequired,
    startDate: PropTypes.string.isRequired,
    endDate: PropTypes.string.isRequired,
    action: PropTypes.string.isRequired,
  }

  render() {
    const {
      time_allocation, startDate, endDate, action, formId,
      buttonDisabled, handleResponse,
    } = this.props

    return (
      <li className='list-group-item'>
        <div className='row'>
          <div className='col-xs-12 text-center'>
            KW {time_allocation.week_number} / {time_allocation.year + ' '}
            <small>
              ({startDate} - {endDate})
            </small>
          </div>
        </div>
        <div className='row'>
          <div className='col-xs-4 text-center'>
            SOLL-Stunden: {time_allocation.desired_wa_hours}
          </div>
          <div className='col-xs-8 text-center'>
            <Form ajax requireValid
              action={action}
              method='POST'
              className='form-inline'
              formObjectClass={ActualWaFormObject}
              id={formId}
              handleResponse={handleResponse}
            >
              <div className='form-group'>
                <InputSet
                  attribute='actual_wa_hours'
                  type='number'
                  min='0'
                  wrapperClassName='input-group spaced'
                  wrapperErrorClassName='has-error'
                  labelClassName='input-group-addon'
                  errorClassName='input-group-addon'
                  className='form-control short'
                  label='IST'
                />
              </div>
              <div className='form-group'>
                <InputSet
                  attribute='actual_wa_comment'
                  wrapperClassName='input-group spaced'
                  wrapperErrorClassName='has-error'
                  labelClassName='input-group-addon'
                  errorClassName='input-group-addon'
                  className='form-control'
                  label='Kommentar'
                  placeholder='(optional)'
                />
              </div>
              <Button
                disabled={buttonDisabled}
                type='submit' className='btn btn-default spaced'
              >
                Abschicken
              </Button>
            </Form>
          </div>
        </div>
      </li>
    )
  }
}
