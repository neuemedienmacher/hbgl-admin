import React, { PropTypes, Component } from 'react'

export default class ExportForm extends Component {
  render() {
    const {
      column_names, associations, action, authToken
    } = this.props

    return (
      <div className='jumbotron ExportForm'>
        <form
          className='form' action={action} method='POST'
        >
          <input type='hidden' name='authenticity_token' value={authToken} />
          <fieldset>
            <legend>Eigene Felder</legend>
            {this.renderCheckboxes('model_fields', column_names)}
          </fieldset>
          {associations.map(([association_name, association_columns]) => {
            return(
              <fieldset key={association_name}>
                <legend>{association_name}</legend>
                {this.renderCheckboxes(association_name, association_columns)}
              </fieldset>
            )
          })}
          <button type="submit" className="btn btn--default">
            CSV Herunterladen
          </button>
        </form>
      </div>
    )
  }

  renderCheckboxes(attribute, column_names) {
    return column_names.map(column_name =>
      this.renderCheckbox(attribute, column_name)
    )
  }

  renderCheckbox(attribute, column_name) {
    const id = `export_${attribute}_${column_name}`

    return(
      <label key={id} className='checkbox-inline'>
        <input
          type='checkbox' id={id}
          name={`export[${attribute}][]`}
          key={column_name} value={column_name}
        />
        {column_name}
      </label>
    )
  }
}
