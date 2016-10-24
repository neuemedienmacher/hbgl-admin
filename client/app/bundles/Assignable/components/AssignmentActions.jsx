import React, { PropTypes, Component } from 'react'
import { Form } from 'rform'

export default class AssignmentActions extends Component {

  render() {
    const {
      assignment, actions
    } = this.props

    return (
      <div className='content AssignmentActions'>
        <table>
          <tbody>
            <tr>
              {actions.map(action => this.renderMinimalFormFor(action))}
            </tr>
          </tbody>
        </table>
      </div>
    )
  }

  renderMinimalFormFor(action) {
    const { handleResponse, afterResponse } = this.props

    return(
      <td key={action.formId}>
        <Form ajax requireValid seedData={action.seedData}
          method={action.method} action={action.href} id={action.formId}
          key={action.formId} formObjectClass={action.formObjectClass}
          handleResponse={handleResponse} afterResponse={afterResponse}
          style='display: inline-block;'
        >
          <button type='submit' className='btn btn-warning btn-assignment'>
            <span className={action.icon} />
          </button>
        </Form>
      </td>
    )
  }
}
