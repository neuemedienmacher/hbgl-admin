import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import OfferTranslationFormObject from '../forms/OfferTranslationFormObject'
import OrganizationTranslationFormObject from
  '../forms/OrganizationTranslationFormObject'
import EditTranslationForm from '../components/EditTranslationForm'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import addEntities from '../../../Backend/actions/addEntities'

const mapStateToProps = (state, ownProps) => {
  const { id, model, translation } = ownProps
  const formId = `${model}Translation${id}`

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
  const stamp = ownProps.translation.offer_stamp ?
                ownProps.translation.offer_stamp.join(', ') : 'nicht angegeben'

  return {
    action,
    seedData,
    formObjectClass,
    properties,
    formId,
    editLink,
    previewLink,
    stamp
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

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(EditTranslationForm)
