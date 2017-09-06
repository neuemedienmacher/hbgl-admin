import { connect } from 'react-redux'
import { setUi } from '../actions/setUi'
import TopNav from '../components/TopNav'

const mapStateToProps = (state, ownProps) => {
  return {
    routes: routesForRole(
      state.entities.users[state.entities['current-user-id']].role
    ),
    activeKey: state.ui.activeKey,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onSelect(eventKey) {
    dispatch(setUi('activeKey', eventKey))
  }
})

const all = ['researcher', 'super']
const superuser = ['super']
const routes = [
  {
    id: 1,
    pathname: '/offer-translations',
    anchor: 'Offer Translations',
    access: all,
  }, {
    id: 2,
    pathname: '/organization-translations',
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
    anchor: 'Divisions',
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
    pathname: '/user-teams',
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
    access: all,
  }, {
    id: 10,
    pathname: '/locations',
    anchor: 'Standorte',
    access: all,
  }, {
    id: 11,
    pathname: '/cities',
    anchor: 'Städte',
    access: all,
  }, {
    id: 12,
    pathname: '/federal-states',
    anchor: 'Bundesländer',
    access: all,
  }, {
    id: 13,
    pathname: '/contact-people',
    anchor: 'Kontaktpersonen',
    access: all,
  }, {
    id: 14,
    pathname: '/emails',
    anchor: 'Emails',
    access: all,
  }, {
    id: 15,
    pathname: '/openings',
    anchor: 'Öffnungszeiten',
    access: all,
  }, {
    id: 16,
    pathname: '/definitions',
    anchor: 'Definitions',
    access: all,
  }, {
    id: 17,
    pathname: '/tags',
    anchor: 'Tags',
    access: all,
  }, {
    id: 18,
    pathname: '/solution-categories',
    anchor: 'Lösungskategorien',
    access: all,
  }, {
    id: 19,
    pathname: '/subscriptions',
    anchor: 'Newsletter Abos',
    access: all,
  }, {
    id: 20,
    pathname: '/update-requests',
    anchor: 'Update Requests',
    access: all,
  }, {
    id: 21,
    pathname: '/split-bases',
    anchor: 'Split Base',
    access: all,
  }/*,
  {
    id: 10,
    pathname: '/statistic-charts',
    anchor: 'Produktivitätsziele',
    access: superuser,
  }, {
    id: 11,
    pathname: '/time-allocations',
    anchor: 'Ressourcenplanung',
    access: superuser,
  }
  */
]

function routesForRole(role) {
  return routes.filter(route => route.access.includes(role))
}

export default connect(mapStateToProps, mapDispatchToProps)(TopNav)
