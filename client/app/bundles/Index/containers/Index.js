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
    ownProps.identifier_addition ? '_' + ownProps.identifier_addition : ''
  const identifier = 'indexResults_' + model + optional
  const uiKey = 'index_' + model + optional
  // const count

  if(pathname.length > 1 && ownProps.location) {
    model = pathname.substr(1, pathname.length)
    query = ownProps.location.query
  }

  return {
    model,
    heading: headingFor(model),
    query,
    identifier,
    uiKey
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
    dispatchProps.dispatch(
      loadAjaxData(nextModel, query, 'indexResults')
    )
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
    return 'Abteilungen'
  case 'offers':
    return 'Angebote'
  case 'offer_translations':
    return 'Angebotsübersetzungen'
  case 'organization_translations':
    return 'Orga-Übersetzungen'
  case 'statistic_charts':
    return 'Produktivitätsziele'
  case 'user_teams':
    return 'Nutzer-Teams'
  case 'users':
    return 'Nutzer'
  case 'assignments':
    return 'Zuweisungen'
  default:
    throw new Error(`Please provide a heading for ${model}`)
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Index)
