import React, { PropTypes, Component } from 'react'
import { Form } from 'react'

export default class ExportForm extends Component {
  render() {
    const {
      column_names, associations
    } = this.props

    return (
      <div className='jumbotron ExportForm'>
        <form
          className="form" action="/bla"
        >
          {column_names.map(column_name =>
            <span>{column_name}</span>
          )}
          {associations.map(association =>
            <div>{association}</div>
          )}
          <button type="submit" className="btn btn--default">
            CSV Herunterladen
          </button>
        </form>
      </div>
    )
  }
}
