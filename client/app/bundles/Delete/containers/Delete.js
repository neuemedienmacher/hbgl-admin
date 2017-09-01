import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { singularize } from '../../../lib/inflection'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import Delete from '../components/Delete'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]
  const action = `/api/v1/${model}/${id}`

  return {
    action,
    model,
    id,
    location: ownProps.location
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    afterSuccess() {
      dispatch(addFlashMessage('success', 'Target Exterminated'))
      browserHistory.push(`/${stateProps.model}`)
    },

    afterError(response) {
      response.text().then((errorMessage) => console.error(errorMessage))
      dispatch(addFlashMessage('error', 'Es gab einen Fehler beim Löschen.'))
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Delete)
