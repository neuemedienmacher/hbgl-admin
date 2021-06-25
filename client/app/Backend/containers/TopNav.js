import { connect } from "react-redux";
import { setUi } from "../actions/setUi";
import TopNav from "../components/TopNav";

const all = ["researcher", "super", ];
const superuser = ["super", ];
const routes = [
  {
    id: 1,
    pathname: "/organizations",
    anchor: "Organisationen",
    access: all
  }, {
    id: 2,
    pathname: "/divisions",
    anchor: "Divisions",
    access: all
  }, {
    id: 3,
    pathname: "/offers",
    anchor: "Angebote",
    access: all
  }, {
    id: 4,
    pathname: "/locations",
    anchor: "Standorte",
    access: all
  }, {
    id: 5,
    pathname: "/contact-people",
    anchor: "Kontaktpersonen",
    access: all
  }, {
    id: 6,
    pathname: "/emails",
    anchor: "Emails",
    access: all
  }, {
    id: 7,
    pathname: "/openings",
    anchor: "Öffnungszeiten",
    access: all
  }, {
    id: 8,
    pathname: "/websites",
    anchor: "Webseiten",
    access: all
  }, {
    id: 9,
    pathname: "/next-steps",
    anchor: "NextSteps",
    access: all
  }, {
    id: 10,
    pathname: "/organization-translations",
    anchor: "Orga Translations",
    access: all
  }, {
    id: 11,
    pathname: "/offer-translations",
    anchor: "Offer Translations",
    access: all
  }, {
    id: 12,
    pathname: "/tags",
    anchor: "Tags",
    access: all
  }, {
    id: 13,
    pathname: "/solution-categories",
    anchor: "Lösungskategorien",
    access: all
  }, {
    id: 14,
    pathname: "/assignments",
    anchor: "Zuweisungen",
    access: all
  }, {
    id: 15,
    pathname: "/definitions",
    anchor: "Definitions",
    access: all
  }, {
    id: 16,
    pathname: "/cities",
    anchor: "Städte",
    access: all
  }, {
    id: 17,
    pathname: "/areas",
    anchor: "Areas",
    access: all
  }, {
    id: 18,
    pathname: "/federal-states",
    anchor: "Bundesländer",
    access: all
  }, {
    id: 19,
    pathname: "/search-locations",
    anchor: "SearchLocations",
    access: all
  }, {
    id: 20,
    pathname: "/language-filters",
    anchor: "Language Filters",
    access: all
  }, {
    id: 21,
    pathname: "/user-teams",
    anchor: "Teams",
    access: superuser
  }, {
    id: 22,
    pathname: "/users",
    anchor: "Nutzer",
    access: superuser
  },
  {
    id: 23,
    pathname: "/v2/federal-states",
    anchor: "Bundesländer V2",
    access: all
  },
];

/**
 * @param role
 */
function routesForRole(role) {
  return routes.filter(route => route.access.includes(role));
}

const mapStateToProps = state => ({
  routes: routesForRole(
    state.entities.users[state.entities["current-user-id"]].role
  ),
  activeKey: state.ui.activeKey
});

const mapDispatchToProps = dispatch => ({
  onSelect(eventKey) {
    dispatch(setUi("activeKey", eventKey));
  }
});

export default connect(mapStateToProps, mapDispatchToProps)(TopNav);
