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
  console.log(filterArray)
  const filters = filterArray // toObject(filterArray)
  // console.log(filters)
  const plusButtonDisabled = ownProps.params.hasOwnProperty('filters[id][]')
  const generalActions = settings.index[ownProps.model].general_actions
  const routes = generalRoutes(ownProps.model, ownProps.params).filter(route =>
    generalActions.includes(route.action)
  )
  // const filterKeys = filterArray.map(function(key) { return key[0] })
  console.log('before', ownProps.params)
  // filterParams(ownProps.params)
  // console.log('after', ownProps.params)
  const params = ownProps.params
  return {
    params,
    filters,
    plusButtonDisabled,
    routes,
  }
}

let lastQueryChangeTimer = null

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onQueryChange(event) {
      const value = event.target.value

      if (lastQueryChangeTimer) clearTimeout(lastQueryChangeTimer)
      lastQueryChangeTimer = setTimeout(function() {
        lastQueryChangeTimer = null

        const params = merge(clone(ownProps.params), { query: value })
        if (window.location.pathname.length > 1) {
          browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
          // browserHistory.replace(`/${ownProps.model}?${jQuery.param(params)}`)
        } else {
          browserHistory.replace(`/?${encode(params)}`)
          // browserHistory.replace(`/?${jQuery.param(params)}`)
        }
      }, 400)
    },

    onPlusClick(event) {
      let params = clone(ownProps.params)
      merge(params, { 'filters[id][]': [''] })

      let query = searchString(ownProps.model, params)
      browserHistory.replace(`/${query}`)
    }
  }
}

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
  return lockedParams != undefined ? lockedParams.hasOwnProperty(key) : false
}

function filterName(key) {
  if (key.lastIndexOf('[]') == key.length - 2){
    return ''
  }
}

function searchString(model, params) {
  // let bla = merge({}, clone(params), { 'filters[id]': ['1', '2']})
  // let bla2 = merge({}, clone(params), { 'filters[id]': {'first': '1', 'second': '2'}})
  // let test = encode(bla)
  // let test2 = encode(bla2)
  // console.log(test)
  // console.log(test2)
  // debugger;
  if(window.location.href.includes(model)) {
    // return `${model}?${jQuery.param(params)}`
    return `${model}?${encode(params)}`
  } else {
    // return `?${jQuery.param(params)}`
    return `?${encode(params)}`
  }
}

function toObject(filters) {
  // if (filters && filters.length){
  //   debugger;
  // }
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
