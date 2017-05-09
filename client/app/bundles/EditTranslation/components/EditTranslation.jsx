import React, { PropTypes, Component } from 'react'
import EditTranslationForm from '../containers/EditTranslationForm'
import AssignableContainer from '../../Assignable/containers/AssignableContainer'

export default class EditTranslation extends Component {

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      heading, current_assignment_id, may_edit, loadData
    } = this.props

    return (
      <div className='content EditTranslation'>
        <AssignableContainer
          assignment_id={current_assignment_id} may_edit={may_edit}
          assignableDataLoad={loadData}
        />
        <h2 className="page-title">{heading}</h2>

        {this.renderLoadingOrForm()}
      </div>
    )
  }

  renderLoadingOrForm() {
    const {
      id, model, loaded, source, translation, may_edit
    } = this.props

    if (loaded) {
      return(
        <EditTranslationForm
          model={model} source={source} id={id} translation={translation}
          may_edit={may_edit}
        />
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }
}
