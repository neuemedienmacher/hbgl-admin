import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Export from '../components/Export'
import { singularize } from '../../../lib/inflection'
import { parse } from 'querystring'

const mapStateToProps = (state, ownProps) => {
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]
  // debugger;
  let ownParams = ownProps.location.query
  if (ownProps.location.hash) {
    ownParams = parse(ownProps.location.hash.split('?')[1])
  }
  filterParams(ownParams)
  return {
    model,
    filterParams: ownParams
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

    loadData() {
      const singularModel = singularize(stateProps.model)

      dispatchProps.dispatch(
        loadAjaxData(
          'field_set/' + singularModel, {}, 'field-set',
          transformResponse, stateProps.model
        )
      )
    }
  }
}

// TODO: refactor/remove this!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function filterParams(params) {
  Object.keys(params).map(function(key) {
    if (key.includes("first")) {
      replaceKey(params, key, "[first]")
    } else if(key.includes("second")) {
      replaceKey(params, key, "[second]")
    }
    return params
  })
}

function replaceKey(params, filterKey, objectKey) {
  let newKey =  filterKey.replace(objectKey, '')
  let newObjectKey = objectKey.replace('[', '').replace(']', '')
  if(params.hasOwnProperty(newKey)) {
    params[newKey][newObjectKey] = params[filterKey]
  } else {
    params[newKey] = { [newObjectKey] : params[filterKey] }
  }
  delete params[filterKey]
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Export)
