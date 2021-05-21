import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import Mailing from '../components/Mailing'

const mapStateToProps = (state, ownProps) => {
  const action = `/api/v1/mailings/${ownProps.id}`
  const modelInstance = state.entities[ownProps.model] &&
    state.entities[ownProps.model][ownProps.id]
  const showSendButton =
    modelInstance && modelInstance.tos === 'uninformed' || false
  const explanationText = showSendButton ?
    'Verschickt eine ToS-Mail an diese Addresse.' :
    'ToS-Mail wurde bereits verschickt.'
  return {
    action,
    showSendButton,
    explanationText,
    authToken: state.settings.authToken
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(nextModel = ownProps.model, nextID = ownProps.id) {
    dispatchProps.dispatch(
      loadAjaxData(`${nextModel}/${nextID}`, '', nextModel)
    )
  },

  afterSuccess() {
    dispatchProps.dispatch(addFlashMessage('success', 'Mail verschickt!'))
    dispatchProps.dispatch(
      loadAjaxData(`${ownProps.model}/${ownProps.id}`, '', ownProps.model)
    )
  },

  afterError(response) {
    const message = 'Es gab einen Fehler beim Versenden der Mail.'
    response.text().then((errorMessage) => console.error(errorMessage))
    dispatch(addFlashMessage('error', message))
  }
})

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Mailing)
