import React, { Component } from 'react'
import EditTranslationForm from '../containers/EditTranslationForm'
import AssignableContainer from '../../Assignable/containers/AssignableContainer'

export default class EditTranslation extends Component {
  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const { heading, t_model, loadData, translation } = this.props

    return (
      <AssignableContainer
        assignable_type={t_model}
        assignable={translation}
        assignableDataLoad={loadData}
      >
        <div className='content EditTranslation'>
          <h2 className='page-title'>{heading}</h2>

          {this.renderLoadingOrForm()}
        </div>
      </AssignableContainer>
    )
  }

  renderLoadingOrForm() {
    const { model, source, id, translation, loaded } = this.props

    if (loaded) {
      return (
        <EditTranslationForm
          model={model}
          source={source}
          id={id}
          translation={translation}
        />
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }
}
