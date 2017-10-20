import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { encode } from 'querystring'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Index from '../components/Index'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import size from 'lodash/size'
import forIn from 'lodash/forIn'

const mapStateToProps = (state, ownProps) => {
  const pathname = window.location.pathname
  let model = ownProps.model
  // let query = ownProps.params
  // const defaultParams = ownProps.defaultParams
  let optional =
    ownProps.identifierAddition ? '_' + ownProps.identifierAddition : ''
  const identifier = 'indexResults_' + model + optional
  let query = merge({},
    merge(clone(ownProps.optionalParams), ownProps.params, ownProps.lockedParams)
  )
  const defaultParams = merge({}, merge(clone(ownProps.optionalParams), ownProps.lockedParams))
  const uiKey = 'index_' + model + optional

  if(pathname.length > 1 && ownProps.location) {
    model = pathname.substr(1, pathname.length)
    query = ownProps.location.query
  }
  //debugger;

  let metaText = 'Waiting for meta information...'
  if (state.ajax[identifier]) {
    let perPage = state.ajax[identifier].meta.per_page
    let startValue = (state.ajax[identifier].meta.current_page - 1) * perPage
    let totalEntries = state.ajax[identifier].meta.total_entries
    let toValue = Math.min(startValue + perPage, totalEntries)
    metaText = `Zeige Ergebnisse ${startValue + 1} bis ${toValue} von insgesamt ${totalEntries}`
  }
  // console.log('query', query)
  // console.log('params', ownProps.params)
  return {
    model,
    heading: headingFor(model),
    query,
    identifier,
    uiKey,
    defaultParams,
    metaText
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(query, nextModel = stateProps.model) {
    // Ugly hack but we don't want to render all assignments in the dashboard
    if (
        !(nextModel == 'assignments' && query == undefined &&
          this.defaultParams !== undefined)
       )
    {
      dispatchProps.dispatch(
        loadAjaxData(nextModel, query, stateProps.identifier)
      )
    }
  },

  onMount() {
    // console.log(this.model)
    // console.log(stateProps.defaultParams)
    // console.log(this.identifier)
    dispatchProps.dispatch(
      loadAjaxData(this.model, stateProps.defaultParams, this.identifier)
    )
    browserHistory.replace(`/?${jQuery.param(stateProps.defaultParams)}`)
  }
})

function headingFor(model) {
  switch(model) {
  case 'organizations':
    return 'Organisationen'
  case 'divisions':
    return 'Divisions'
  case 'offers':
    return 'Angebote'
  case 'offer-translations':
    return 'Angebotsübersetzungen'
  case 'organization-translations':
    return 'Orga-Übersetzungen'
  case 'statistic-charts':
    return 'Produktivitätsziele'
  case 'user-teams':
    return 'Nutzer-Teams'
  case 'users':
    return 'Nutzer'
  case 'assignments':
    return 'Zuweisungen'
  case 'locations':
    return 'Standorte'
  case 'cities':
    return 'Städte'
  case 'openings':
    return 'Öffnungszeiten'
  case 'tags':
    return 'Tags'
  case 'definitions':
    return 'Definitions'
  case 'federal-states':
    return 'Bundesländer'
  case 'contact-people':
    return 'Kontaktpersonen'
  case 'solution-categories':
    return 'Lösungskategorien'
  case 'split-bases':
    return 'Split Base'
  case 'emails':
    return 'Emails'
  case 'subscriptions':
    return 'Newsletter Abos'
  case 'update-requests':
    return 'Update Requests'
  default:
    throw new Error(`Please provide a heading for ${model}`)
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Index)
