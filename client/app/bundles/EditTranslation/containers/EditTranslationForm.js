import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import addEntities from '../../../Backend/actions/addEntities'
import OfferTranslationFormObject from '../forms/OfferTranslationFormObject'
import OrganizationTranslationFormObject from
  '../forms/OrganizationTranslationFormObject'
import EditTranslationForm from '../components/EditTranslationForm'

const mapStateToProps = (state, ownProps) => {
  const { id, model, translation } = ownProps
  const formId = `${model}Translation${id}`

  const action = `/api/v1/${model}_translations/${id}`
  const seedData = {
    fields: translation
  }
  const formObjectClass =
    (model == 'offer') ? OfferTranslationFormObject
                       : OrganizationTranslationFormObject
  const properties = formObjectClass.properties
  return {
    action,
    seedData,
    formObjectClass,
    properties,
    formId,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  handleResponse: (_formId, data) => dispatch(addEntities(data)),

  afterResponse(response) {
    if (response.data && response.data.id) {
      browserHistory.push(`/${ownProps.model}_translations`)
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
