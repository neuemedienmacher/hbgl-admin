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
  case 'offers':
    return 'Angebote'
  case 'offer_translations':
    return 'Angebotsübersetzungen'
  case 'organization_translations':
    return 'Orga-Übersetzungen'
  case 'productivity_goals':
    return 'Produktivitätsziele'
  case 'user_teams':
    return 'Nutzer-Teams'
  case 'users':
    return 'Nutzer'
  default:
    throw new Error(`Please provide a heading for ${model}`)
  }
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Index)
