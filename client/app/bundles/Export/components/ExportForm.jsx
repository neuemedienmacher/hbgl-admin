import React, { PropTypes, Component } from 'react'

export default class ExportForm extends Component {
  render() {
    const {
      columnNames, associations, action, authToken
    } = this.props

    return (
      <div className='jumbotron ExportForm'>
        <form
          className='form' action={action} method='POST'
        >
          <input type='hidden' name='authenticity_token' value={authToken} />
          <fieldset>
            <legend>Eigene Felder</legend>
            {this.renderCheckboxes('model_fields', columnNames)}
          </fieldset>
          {associations.map(([associationName, associations]) => {
            return(
              <fieldset key={associationName}>
                <legend>{associationName}</legend>
                {this.renderCheckboxes(associationName, associations.columns)}
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

  renderCheckboxes(attribute, columnNames) {
    return columnNames.map(columnName =>
      this.renderCheckbox(attribute, columnName)
    )
  }

  renderCheckbox(attribute, columnName) {
    const id = `export_${attribute}_${columnName}`

    return(
      <label key={id} className='checkbox-inline'>
        <input
          type='checkbox' id={id}
          name={`export[${attribute}][]`}
          key={columnName} value={columnName}
        />
        {columnName}
      </label>
    )
  }
}
