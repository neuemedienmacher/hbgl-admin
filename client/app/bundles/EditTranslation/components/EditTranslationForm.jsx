import React, { PropTypes, Component } from 'react'
import { Form, InputSet, Button } from 'rform'
import EditTranslationRow from '../containers/EditTranslationRow'

export default class EditTranslationForm extends Component {
  render() {
    const {
      seedData, action, formObjectClass, source, properties, formId,
      afterResponse, mayEdit, editLink, previewLink
    } = this.props

    return (
      <Form ajax requireValid
        method='PATCH' action={action}
        id={formId} seedData={seedData} formObjectClass={formObjectClass}
        afterResponse={afterResponse}
      >
        <fieldset>
          <table className="table table-condensed offer-translations--form-table">
            <tbody>
              <tr>
                <th className='translation'>
                  Übersetzung von {this.renderTranslationSource()}
                </th>
                <th className='original'>
                  <a href={editLink} target='_blank'><i className="fa fa-file-text" /> Original</a> &nbsp;&nbsp;&nbsp;
                  <a href={previewLink} target='_blank'><i className="fa fa-eye" /> Preview</a>
                </th>
              </tr>
              {properties.map(property => {
                return(
                  <EditTranslationRow
                    key={property} property={property} formId={formId}
                    source={source} mayEdit={mayEdit}
                  />
                )
              })}
            </tbody>
          </table>
        </fieldset>
        <Button
          className='btn btn-primary'
          disableOnInvalid disableOnUnchanged
          label='Speichern' unchangedDisabledLabel='Gespeichert!'
          invalidDisabledLabel='Es existieren Formular-Fehler!'
        />
      </Form>
    )
  }

  renderTranslationSource() {
    if (this.props.translation.source == 'GoogleTranslate') {
      return <span className='text-danger translation-marker'>GoogleTranslate</span>
    }
    else if (this.props.translation.possibly_outdated) {
      return(
        <span className='text-warning translation-marker'>
          Menschenhand
          <dfn title='möglicherweise veraltet'>*</dfn>
        </span>
      )
    }
    else {
      return <span className='text-success translation-marker'>Menschenhand</span>
    }
  }
}
