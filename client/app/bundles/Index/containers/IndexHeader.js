import { connect } from "react-redux";
import merge from "lodash/merge";
import clone from "lodash/clone";
import pickBy from "lodash/pickBy";
import toPairs from "lodash/toPairs";
import get from "lodash/get";
import { browserHistory } from "react-router";
import settings from "../../../lib/settings";
import IndexHeader from "../components/IndexHeader";

const mapStateToProps = (state, ownProps) => {
  const filterArray = toPairs(
    pickBy(ownProps.params, (value, key) =>
      key.substr(0, 7) === "filters" &&
        lockedParamsHaveKey(key, ownProps.lockedParams) === false)
  );
  const filters = toObject(filterArray);

  let plusButtonDisabled = false;

  if (ownProps.params && ownProps.params.hasOwnProperty) {
    plusButtonDisabled = ownProps.params.hasOwnProperty("filters[id]");
  }

  filterParams(ownProps.params);

  const generalActions = get(settings.index[ownProps.model], "general_actions",[]);
  const routes = generalRoutes(ownProps.model, ownProps.params).filter(route =>
    generalActions.includes(route.action));
  const params = ownProps.params;

  return {
    params,
    filters,
    plusButtonDisabled,
    routes
  };
};

let lastQueryChangeTimer = null;

const mapDispatchToProps = (dispatch, ownProps) => ({
  onQueryChange(event) {
    const value = event.target.value;

    if (lastQueryChangeTimer) {
      clearTimeout(lastQueryChangeTimer);
    }
    lastQueryChangeTimer = setTimeout(() => {
      lastQueryChangeTimer = null;

      const params = merge(clone(ownProps.params), { query: value });

      if (window.location.pathname.length > 1) {

        // browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
        browserHistory.replace(`/${ownProps.model}?${jQuery.param(params)}`);
      } else {

        // browserHistory.replace(`/?${encode(params)}`)
        browserHistory.replace(`/?${jQuery.param(params)}`);
      }
    }, 400);
  },

  onPlusClick(event) {
    const params = clone(ownProps.params);

    merge(params, { "filters[id]": "" });

    const query = searchString(ownProps.model, params);

    browserHistory.replace(`/${query}`);
  }
});

const generalRoutes = (model, params) => [
  {
    id: 1,
    action: "index",
    pathname: `/${model}`,
    anchor: "Liste"
  }, {
    id: 2,
    action: "new",
    pathname: `/${model}/new`,
    anchor: "Erstellen"
  }, {
    id: 3,
    action: "export",
    pathname: `/${model}/export`,
    hash: `?${jQuery.param(params)}`,
    anchor: "Export"
  },
];

/**
 * @param key
 * @param lockedParams
 * @returns Boolean
 */
function lockedParamsHaveKey(key, lockedParams) {
  if (lockedParams) {
    if (lockedParams.hasOwnProperty(key)) {
      return true;
    }
    return false;

  }
  return false;

}

/**
 * @param model
 * @param params
 */
function searchString(model, params) {
  if (window.location.href.includes(model)) {
    return `${model}?${jQuery.param(params)}`;

    // return `${model}?${encode(params)}`
  }
  return `?${jQuery.param(params)}`;

  // return `?${encode(params)}`

}

/**
 * @param filters
 */
function toObject(filters) {
  const filterArray = filters.map(filter => {
    if (filter[0].includes("first")) {
      const newKey = filter[0].replace("[first]", "");

      return [ newKey, { first: filter[1] }, ];
    }
    if (filter[0].includes("second")) {
      const newKey = filter[0].replace("[second]", "");

      return [ newKey, { second: filter[1] }, ];
    }
    return [ filter[0], filter[1], ];

  });

  return filterArray;
}

/**
 * @param params
 */
function filterParams(params) {
  Object.keys(params).map(key => {
    if (key.includes("first")) {
      replaceKey(params, key, "[first]");
    } else if (key.includes("second")) {
      replaceKey(params, key, "[second]");
    }
    return params;
  });
}

/**
 * @param params
 * @param filterKey
 * @param objectKey
 */
function replaceKey(params, filterKey, objectKey) {
  const newKey = filterKey.replace(objectKey, "");
  const newObjectKey = objectKey.replace("[", "").replace("]", "");

  if (params.hasOwnProperty(newKey)) {
    params[newKey][newObjectKey] = params[filterKey];
  } else {
    params[newKey] = { [newObjectKey]: params[filterKey] };
  }
  delete params[filterKey];
}

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeader);
