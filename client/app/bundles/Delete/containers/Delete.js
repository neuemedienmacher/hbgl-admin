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
    const message = 'Objekt kann nicht gelöscht werden, da andere mit ihm verknüpfte Objekte nicht mehr valide wären. Bei Fragen wende dich an die IT.'
    response.text().then((errorMessage) => console.error(errorMessage))
    dispatch(addFlashMessage('error', message))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Delete)
