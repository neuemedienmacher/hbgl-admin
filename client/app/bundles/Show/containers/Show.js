import { connect } from 'react-redux'
import { singularize } from '../../../lib/inflection'
import { handleError } from '../../../lib/ajaxRedirectHandler'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Show from '../components/Show'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]

  return {
    id,
    model
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  // This response does not follow JSON API format, we need to transform it
  // manually
  const transformResponse = function(apiResponse, nextModel) {
    let object = { 'field-sets': {} }
    object['field-sets'][nextModel] = apiResponse
    return object
  }

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
            transformer: transformResponse, nextModel
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
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Show)
