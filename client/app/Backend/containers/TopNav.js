import { connect } from 'react-redux'
import setUiAction from '../actions/setUi'
import TopNav from '../components/TopNav'

const mapStateToProps = (state, ownProps) => {
  return {
    routes: routesForRole(state.entities.current_user.role),
    activeKey: state.ui.activeKey,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onSelect(eventKey) {
    dispatch(setUiAction('activeKey', eventKey))
  }
})

const all = ['researcher', 'super']
const superuser = ['super']
const routes = [
  {
    id: 1,
    pathname: '/offer_translations',
    anchor: 'Offer Translations',
    access: all,
  }, {
    id: 2,
    pathname: '/organization_translations',
    anchor: 'Orga Translations',
    access: all,
  }, {
    id: 3,
    pathname: '/statistics',
    anchor: 'Statistiken',
    access: superuser,
  }, {
    id: 4,
    pathname: '/productivity_goals',
    anchor: 'Produktivitätsziele',
    access: superuser,
  }, {
    id: 5,
    pathname: '/time_allocations',
    anchor: 'Ressourcenplanung',
    access: superuser,
  }
]

function routesForRole(role) {
  return routes.filter(route => route.access.includes(role))
}

export default connect(mapStateToProps, mapDispatchToProps)(TopNav)
