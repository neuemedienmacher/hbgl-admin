import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { singularize } from '../../../lib/inflection'
import { handleError } from '../../../lib/ajaxRedirectHandler'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import Delete from '../components/Delete'

const mapStateToProps = (state, ownProps) => {
  const action = `/api/v1/${ownProps.model}/${ownProps.id}`

  return {
    action,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  afterSuccess() {
    dispatch(addFlashMessage('success', 'Target Exterminated'))
    browserHistory.goBack()
  },

  afterError(response) {
    response.text().then((errorMessage) => console.error(errorMessage))
    dispatch(addFlashMessage('error', 'Es gab einen Fehler beim Löschen.'))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Delete)
