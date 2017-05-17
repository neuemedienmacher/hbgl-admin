import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Show from '../components/Show'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]
  const heading = model.substr(0, model.length - 1) + '#' + id

  return {
    id,
    model,
    heading
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
      const singularModel = nextModel.substr(0, nextModel.length - 1)

      // load field_set (all fields and associations of current model)
      dispatchProps.dispatch(
        loadAjaxData(
          'field_set/' + singularModel, {}, 'field-set', transformResponse,
          nextModel
        )
      )
      // load data of current model_instance
      dispatchProps.dispatch(
        loadAjaxData(`${nextModel}/${nextID}`, '', nextModel)
      )
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Show)
