import { connect } from "react-redux";
import loadAjaxData from "../../../Backend/actions/loadAjaxData";
import Index from "../components/Index";

const headingTranslation = {
  "organizations": "Organisationen",
  "divisions": "Divisions",
  "offers": "Angebote",
  "offer-translations": "Angebotsübersetzungen",
  "organization-translations": "Orga-Übersetzungen",
  "statistics-charts": "Produktivitätsziele",
  "user-teams": "Nutzer-Teams",
  "users": "Nutzer",
  "assignments": "Zuweisungen",
  "locations": "Standorte",
  "cities": "Städte",
  "openings": "Öffnungszeiten",
  "tags": "Tags",
  "definitions": "Definitionen",
  "federal-states": "Bundesländer",
  "contact-people": "Kontaktpersonen",
  "solution-categories": "Lösungskategorien",
  "emails": "Emails",
  "subscriptions": "Newsletter Abos",
  "update-requests": "Update Anfragen",
  "websites": "Webseiten",
  "next-steps": "Nächste Schritte",
  "areas": "Gebiete",
  "search-locations": "SearchLocations",
  "contacts": "Kontakte",
  "language-filters": "Languagefilter",
};

const headingFor = (modelName) => {
  const translation = headingTranslation[modelName];
  if (translation) return translation;
  throw new Error(`Please provide a headline for ${modelName}`);
};

const mapStateToProps = (state, ownProps) => {
  const pathname = window.location.pathname;
  let model = ownProps.model;
  let query = ownProps.params;
  let optional =
    ownProps.identifierAddition ? "_" + ownProps.identifierAddition : "";
  const identifier = "indexResults_" + model + optional;
  const defaultParams = ownProps.defaultParams;
  const uiKey = "index_" + model + optional;

  if (pathname.length > 1 && ownProps.location) {
    model = pathname.substr(1, pathname.length);
    query = ownProps.location.query;
  }
  const isLoading = state.ajax.isLoading[identifier];
  let metaText = "Suche...";
  if (!isLoading && state.ajax[identifier]) {
    let perPage = state.ajax[identifier].meta.per_page;
    let startValue = (state.ajax[identifier].meta.current_page - 1) * perPage;
    let totalEntries = state.ajax[identifier].meta.total_entries;
    let toValue = Math.min(startValue + perPage, totalEntries);
    metaText = (totalEntries === 0) ?
      "Es wurden keine Ergebnisse gefunden." :
      `Zeige Ergebnisse ${startValue + 1} bis ${toValue}` +
        ` von insgesamt ${totalEntries}.`;
  }
  return {
    model,
    heading: headingFor(model),
    query,
    identifier,
    uiKey,
    defaultParams,
    metaText,
    isLoading
  };
};

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
});

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(query, nextModel = stateProps.model) {
    // Ugly hack but we don"t want to render all assignments in the dashboard
    if (
        !(nextModel === "assignments" && query === undefined &&
          this.defaultParams !== undefined)
       )
    {
      dispatchProps.dispatch(
        loadAjaxData(nextModel, query, stateProps.identifier)
      );
    }
  }
});

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(Index);
