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
    pickBy(ownProps.params, (value, key) => key.substr(0, 6) == 'filter')
  )
  const plusButtonDisabled = ownProps.params.hasOwnProperty('filter[id]')

  const generalActions = settings.index[ownProps.model].general_actions
  const routes = generalRoutes(ownProps.model, ownProps.params).filter(route =>
    generalActions.includes(route.action)
  )

  return {
    ...ownProps.params,
    filters,
    plusButtonDisabled,
    routes,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onQueryChange(event) {
    const params = merge(clone(ownProps.params), { query: event.target.value })
    browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
  },

  onPlusClick(event) {
    let params = clone(ownProps.params)
    if (params['filter[id]']) return // ID filtered - other filters not needed
    merge(params, { 'filter[id]': '' })
    browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
  }
})

const generalRoutes = (model, params) => [
  {
    id: 1,
    action: 'index',
    pathname: `/${model}`,
    anchor: 'Liste',
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
    anchor: 'Export',
  }
]

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeader)
