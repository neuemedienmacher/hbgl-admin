import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import OfferTranslationFormObject from '../forms/OfferTranslationFormObject'
import OrganizationTranslationFormObject from
  '../forms/OrganizationTranslationFormObject'
import EditTranslationForm from '../components/EditTranslationForm'
import generateFormId from '../../GenericForm/lib/generateFormId'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import addEntities from '../../../Backend/actions/addEntities'

const mapStateToProps = (state, ownProps) => {
  const { id, model, translation } = ownProps
  // const formId = `${model}Translation${id}`
  const formId = generateFormId(model, '', 'translation', id)
  const action = `/api/v1/${model}-translations/${id}`
  const seedData = {
    fields: translation
  }
  const formObjectClass =
    (model == 'offer') ? OfferTranslationFormObject
                       : OrganizationTranslationFormObject
  const properties = formObjectClass.properties
  const editLink = `/admin/${model}/${ownProps.source.id}/edit`
  const previewLink = `/admin/${model}/${ownProps.source.id}/show_in_app`
  const stamp = ownProps.translation['offer-stamp'] ?
                ownProps.translation['offer-stamp'].join(', ') : 'nicht angegeben'
  const buttonData = BUTTON_DATA

  return {
    action,
    seedData,
    formObjectClass,
    properties,
    formId,
    editLink,
    previewLink,
    stamp,
    buttonData
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  afterResponse(_formId, changes, errors, _meta, response) {
    if (response.data && response.data.id) {
      dispatch(addFlashMessage('success', 'Erfolgreich gespeichert!'))
      dispatch(addEntities(changes))
    } else if (errors && errors.length) {
      dispatch(addFlashMessage('error', 'Fehler beim speichern'))
    }
  }
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,
})

const BUTTON_DATA = [{
// start with default save button (might be extended)
  className: 'btn btn-primary',
  buttonLabel: 'Speichern',
  actionName: ''
},{
  className: 'btn btn-primary',
  buttonLabel: 'Speichern und Zuweisung schließen',
  actionName: 'closeAssignment'
}]

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(EditTranslationForm)
