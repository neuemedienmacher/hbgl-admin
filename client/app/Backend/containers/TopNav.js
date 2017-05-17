import { connect } from 'react-redux'
import setUiAction from '../actions/setUi'
import TopNav from '../components/TopNav'

const mapStateToProps = (state, ownProps) => {
  return {
    routes: routesForRole(state.entities['current-user'].role),
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
    pathname: '/organizations',
    anchor: 'Organisationen',
    access: all,
  }, {
    id: 4,
    pathname: '/divisions',
    anchor: 'Abteilungen',
    access: all,
  }, {
    id: 5,
    pathname: '/offers',
    anchor: 'Angebote',
    access: all,
  }, {
    id: 6,
    pathname: '/statistics',
    anchor: 'Statistiken',
    access: all,
  }, {
    id: 7,
    pathname: '/user_teams',
    anchor: 'Teams',
    access: superuser,
  }, {
    id: 8,
    pathname: '/users',
    anchor: 'Nutzer',
    access: superuser,
  }, {
    id: 9,
    pathname: '/assignments',
    anchor: 'Zuweisungen',
    access: superuser,
  }/*,
  {
    id: 10,
    pathname: '/statistic_charts',
    anchor: 'Produktivitätsziele',
    access: superuser,
  }, {
    id: 11,
    pathname: '/time_allocations',
    anchor: 'Ressourcenplanung',
    access: superuser,
  }
  */
]

function routesForRole(role) {
  return routes.filter(route => route.access.includes(role))
}

export default connect(mapStateToProps, mapDispatchToProps)(TopNav)
