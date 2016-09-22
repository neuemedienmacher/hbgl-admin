import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'
import EditTranslationRow from '../containers/EditTranslationRow'

export default class EditTranslationForm extends Component {
  render() {
    const {
      seedData, action, formObjectClass, source, properties, formId
    } = this.props

    return (
      <Form ajax requireValid
        id={formId}
        method='PATCH'
        action={action}
        seedData={seedData}
        formObjectClass={formObjectClass}
      >
        <fieldset>
          <table className="table table-condensed offer-translations--form-table">
            <tbody>
              <tr>
                <th className='translation'>
                  Übersetzung von {this.renderTranslationSource()}
                </th>
                <th className='original'>
                  Original {/*TODO: Link to edit*/}
                </th>
              </tr>
              {properties.map(property => {
                return(
                  <EditTranslationRow
                    key={property} property={property} formId={formId}
                    source={source}
                  />
                )
              })}
            </tbody>
          </table>
        </fieldset>
        <button type='submit' className='btn btn--default'>
          Aktualisieren
        </button>
      </Form>
    )
  }

  renderTranslationSource() {
    if (this.props.translation.source == 'GoogleTranslate') {
      return <span className='text-danger'>GoogleTranslate</span>
    }
    else if (this.props.translation.possibly_outdated) {
      return(
        <span className='text-warning'>
          Menschenhand
          <dfn title='möglicherweise veraltet'>*</dfn>
        </span>
      )
    }
    else {
      return <span className='text-success'>Menschenhand</span>
    }
  }
}
