import React, { PropTypes, Component } from 'react'
import EditTranslationForm from '../containers/EditTranslationForm'

export default class EditTranslation extends Component {
  componentDidMount() {
    // Load
    this.props.loadData()
  }

  render() {
    return (
      <div className='content EditTranslation'>
        <h2>{this.props.heading}</h2>

        {this.renderLoadingOrForm()}
      </div>
    )
  }

  renderLoadingOrForm() {
    const {
      id, model, loaded, source, translation
    } = this.props

    if (loaded) {
      return(
        <EditTranslationForm
          model={model} source={source} id={id} translation={translation}
        />
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }
}
