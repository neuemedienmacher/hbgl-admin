import React, { PropTypes } from 'react'
import { Form, InputSet, Button } from 'rform'
import ActualWaForm from './ActualWaForm'
import ActualWaFormObject from '../forms/ActualWaForm'

export default class ActualWaList extends React.Component {
  static propTypes = {
    time_allocation: PropTypes.object.isRequired,
    startDate: PropTypes.string.isRequired,
    endDate: PropTypes.string.isRequired,
    action: PropTypes.string.isRequired,
    authToken: PropTypes.string.isRequired,
  }

  render() {
    const {
      time_allocation, startDate, endDate, action, authToken, formId,
      buttonDisabled,
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
          <div className='col-xs-5 text-center'>
            SOLL: {time_allocation.desired_wa_hours} Stunden
          </div>
          <div className='col-xs-7 text-center'>
            <Form ajax requireValid
              action={action}
              method='POST'
              className='form-inline'
              formObjectClass={ActualWaFormObject}
              id={formId}
            >
              <div className='form-group'>
                <InputSet
                  attribute='actual_wa_hours'
                  type='number'
                  min='0'
                  wrapperClassName='input-group'
                  wrapperErrorClassName='has-error'
                  labelClassName='input-group-addon'
                  errorClassName='input-group-addon'
                  className='form-control'
                  label='IST'
                />
              </div>
              <Button
                disabled={buttonDisabled}
                type='submit' className='btn btn-default'
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
