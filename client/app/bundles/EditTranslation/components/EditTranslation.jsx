import React, { PropTypes, Component } from 'react'
import EditTranslationForm from '../containers/EditTranslationForm'
import AssignableContainer from '../../Assignable/containers/AssignableContainer'

export default class EditTranslation extends Component {

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      heading, currentAssignmentId, mayEdit, loadData
    } = this.props

    return (
      <div className='content EditTranslation'>
        <AssignableContainer
          assignmentId={currentAssignmentId} mayEdit={mayEdit}
          assignableDataLoad={loadData}
        />
        <h2 className="page-title">{heading}</h2>

        {this.renderLoadingOrForm()}
      </div>
    )
  }

  renderLoadingOrForm() {
    const {
      id, model, loaded, source, translation, mayEdit
    } = this.props

    if (loaded) {
      return(
        <EditTranslationForm
          model={model} source={source} id={id} translation={translation}
          mayEdit={mayEdit}
        />
      )
    } else {
      return <div className='text-center'>Lade...</div>
    }
  }
}
