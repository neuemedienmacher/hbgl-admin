import { connect } from 'react-redux'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import pickBy from 'lodash/pickBy'
import toPairs from 'lodash/toPairs'
import { encode } from 'querystring'
import { browserHistory } from 'react-router'
import settings from '../../../lib/settings'
import IndexHeader from '../components/IndexHeader'

const mapStateToProps = (state, ownProps) => {
  const filterArray = toPairs(
    pickBy(ownProps.params, (value, key) =>
      key.substr(0, 7) == 'filters' &&
        lockedParamsHaveKey(key, ownProps.lockedParams) == false)
  )
  const filters = toObject(filterArray)
  const plusButtonDisabled = ownProps.params.hasOwnProperty('filters[id]')
  const filterKeys = filterArray.map(function(key) { return key[0] })
  filterParams(ownProps.params)
  const generalActions = settings.index[ownProps.model].general_actions
  const routes = generalRoutes(ownProps.model, ownProps.params).filter(route =>
    generalActions.includes(route.action)
  )
  const params = ownProps.params
  return {
    params,
    filters,
    plusButtonDisabled,
    routes
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onQueryChange(event) {
    const params = merge(clone(ownProps.params), { query: event.target.value })
    if (window.location.pathname.length > 1) {
      // browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
      browserHistory.replace(`/${ownProps.model}?${jQuery.param(params)}`)
    } else {
      // browserHistory.replace(`/?${encode(params)}`)
      browserHistory.replace(`/?${jQuery.param(params)}`)
    }
  },

  onPlusClick(event) {
    let params = clone(ownProps.params)
    merge(params, { 'filters[id]': '' })

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
  }
})

const generalRoutes = (model, params) => [
  {
    id: 1,
    action: 'index',
    pathname: `/${model}`,
    anchor: 'Liste'
  }, {
    id: 2,
    action: 'new',
    pathname: `/${model}/new`,
    anchor: 'Erstellen'
  }, {
    id: 3,
    action: 'export',
    pathname: `/${model}/export`,
    hash: `?${jQuery.param(params)}`,
    anchor: 'Export'
  }
]

function lockedParamsHaveKey(key, lockedParams) {
  if(lockedParams) {
    if(lockedParams.hasOwnProperty(key)) {
      return true
    } else {
      return false
    }
  } else {
    return false
  }
}

function searchString(model, params) {
  if(window.location.href.includes(model)) {
    return `${model}?${jQuery.param(params)}`
    // return `${model}?${encode(params)}`
  } else {
    return `?${jQuery.param(params)}`
    // return `?${encode(params)}`
  }
}

function toObject(filters) {
  var filterArray = filters.map(function(filter) {
    if (filter[0].includes("first")) {
      const newKey = filter[0].replace("[first]", "")
      return [ newKey, { "first": filter[1] } ]
    } else if(filter[0].includes("second")) {
      const newKey =  filter[0].replace("[second]", "")
      return [ newKey, { "second":  filter[1] } ]
    } else {
      return [ filter[0], filter[1] ]
    }
  })
  return filterArray
}

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

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeader)
