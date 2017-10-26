import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { singularize } from '../../../lib/inflection'
import { handleError } from '../../../lib/ajaxRedirectHandler'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
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

    loadData(nextModel = stateProps.model, nextID = stateProps.id) {
      const singularModel = singularize(nextModel)

      // load field_set (all fields and associations of current model)
      dispatchProps.dispatch(
        loadAjaxData(
          'field_set/' + singularModel, {}, 'field-set', {
            transformer: undefined, nextModel
          }
        )
      )
      // load data of current model_instance
      dispatchProps.dispatch(
        loadAjaxData(
          `${nextModel}/${nextID}`, '', nextModel,
          { onError: handleError(nextModel, dispatchProps.dispatch) }
        )
      )
    },

    afterSuccess() {
      dispatch(addFlashMessage('success', 'Target Exterminated'))
      browserHistory.goBack()
    },

    afterError(response) {
      response.text().then((errorMessage) => console.error(errorMessage))
      dispatch(addFlashMessage('error', 'Es gab einen Fehler beim Löschen.'))
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Delete)
