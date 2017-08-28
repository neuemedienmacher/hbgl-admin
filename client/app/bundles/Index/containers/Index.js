import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Index from '../components/Index'
import merge from 'lodash/merge'
import clone from 'lodash/clone'
import size from 'lodash/size'
import forIn from 'lodash/forIn'

const mapStateToProps = (state, ownProps) => {
  const pathname = window.location.pathname
  let model = ownProps.model
  let query = ownProps.params
  let optional =
    ownProps.identifierAddition ? '_' + ownProps.identifierAddition : ''
  const identifier = 'indexResults_' + model + optional
  const defaultParams = ownProps.defaultParams
  const uiKey = 'index_' + model + optional

  if(pathname.length > 1 && ownProps.location) {
    model = pathname.substr(1, pathname.length)
    query = ownProps.location.query
  }

  return {
    model,
    heading: headingFor(model),
    query,
    identifier,
    uiKey,
    defaultParams
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
        loadAjaxData(nextModel, query, 'indexResults')
      )
    }
  },

  equalParams(params1, params2) {
    if (size(params1) != size(params2)) return false
    let isSame = true
    forIn(params1, (value, key) => {
      if(!isSame || params2[key] != value) {
        isSame = false
      }
    })
    return isSame
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
  case 'emails':
    return 'Emails'
  default:
    throw new Error(`Please provide a heading for ${model}`)
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Index)
