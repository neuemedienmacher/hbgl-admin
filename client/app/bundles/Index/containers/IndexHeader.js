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
  const filters = toPairs(
    pickBy(ownProps.params, (value, key) => 
      key.substr(0, 7) == 'filters' && 
        //ownProps.lockedParams.hasOwnProperty(key) == false)
        lockedParamsHaveKey(key, ownProps.lockedParams) == false)
  )
  const plusButtonDisabled = ownProps.params.hasOwnProperty('filters[id]')
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
    if(window.location.pathname.length > 1) {
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    } else {
      browserHistory.replace(`/?${encode(params)}`)
    }
  },

  onPlusClick(event) {
    let params = clone(ownProps.params)
    merge(params, { 'filters[id]': '' })

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
    // if (params['filters[id]']) return // ID filtered - other filters not needed
    // if(window.location.pathname.length > 1) {
    //   merge(params, { 'filters[id]': '' })
    //   debugger
    //   browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    //   window.location.reload()
    // } else {
    //   //if (params['filters[id]']) return
    //   merge(params, { 'filters[id]': '' })
    //   browserHistory.replace(`/?${encode(params)}`) //used in Dashboard
    // }
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
    query: params,
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
    return `${model}?${encode(params)}`
  } else {
    return `?${encode(params)}`
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeader)
