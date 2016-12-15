import React, { PropTypes } from 'react'
import { Form, InputSet } from 'rform'
import FilteringSelect from '../../FilteringSelect/wrappers/FilteringSelect'
import InlineCreate from '../../InlineCreate/wrappers/InlineCreate'
import OrganizationFormObject from '../forms/OrganizationFormObject'

export default class NewOrganizationForm extends React.Component {
  render() {
    const {
      formId,
    } = this.props

    return (
      <div className='content NewOrganization'>
        <h2>Neue Zuweisung</h2>
        <hr />
        <Form ajax requireValid
          action='/api/v1/organizations/' method='POST'
          className='form'
          id={formId}
          formObjectClass={OrganizationFormObject}
        >
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Name' attribute='name'
          />
          <FilteringSelect multi
            wrapperClassName='form-group' className='form-control'
            label='Webseiten' attribute='website_ids'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='clarat Welt' attribute='section_filter_ids'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Problemkategorien' attribute='category_ids'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Lösungskategorien' attribute='solution_category_ids'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Zustand' attribute='todo'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Notizen' attribute='mussditsein'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Hohe Priorität' attribute='priority'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Kooperationsorganisationen' attribute='srsly'
          />
          <InputSet
            wrapperClassName='form-group' className='form-control'
            label='Reichweite' attribute='isntthatencounter'
          />
          <InlineCreate
            model='divisions' idOrNew='new' edit={null}
            wrapperClassName='form-group' className='form-control'
            label='Abteilungen' attribute='divisions'
          />
          <button className='btn btn-default' type='submit' disabled='disabled'>
            Erstellen
          </button>
        </Form>
      </div>
    )
  }
}
