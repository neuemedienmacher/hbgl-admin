import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import Index from '../components/Index'

const mapStateToProps = (state, ownProps) => {
  const pathname = ownProps.location.pathname
  const model = pathname.substr(1, pathname.length)

  return {
    model,
    heading: headingFor(model),
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(query = ownProps.location.query, nextModel = stateProps.model) {
    dispatchProps.dispatch(
      loadAjaxData(nextModel, query, 'indexResults')
    )
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
  case 'federal_states':
    return 'Bundesländer'
  case 'contact_people':
    return 'Kontaktpersonen'
  case 'emails':
    return 'Emails'
  default:
    throw new Error(`Please provide a heading for ${model}`)
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Index)
