import GenericFormObject from "../lib/GenericFormObject";
import merge from "lodash/merge";
import concat from "lodash/concat";
import WebsiteFormObject from "./WebsiteFormObject";
import { DivisionCreateFormObject } from "./DivisionFormObject";
import LocationFormObject from "./LocationFormObject";
import ContactPersonFormObject from "./ContactPersonFormObject";

import { ONE_TO_MANY, ONE_TO_ONE, BELONGS_TO } from "../../../lib/constants";

class OrgaCreateFormObject extends GenericFormObject {
  static get model() {
    return "organization";
  }

  static get type() {
    return "organizations";
  }

  static get properties() {
    return [
      "name", "description", "website", "locations", "contact-people",
      "comment", "priority", "pending-reason", "divisions", "topics",
    ];
  }

  static get submodels() {
    return ["website", "divisions", "locations", "contact-people", "topics", ];
  }

  static get submodelConfig() {
    return {
      website: {
        object: WebsiteFormObject,
        relationship: ONE_TO_ONE
      },
      divisions: {
        object: DivisionCreateFormObject,
        relationship: ONE_TO_MANY,
        inverseRelationship: BELONGS_TO
      },
      locations: {
        object: LocationFormObject,
        relationship: ONE_TO_MANY,
        inverseRelationship: BELONGS_TO
      },
      "contact-people": {
        object: ContactPersonFormObject,
        relationship: ONE_TO_MANY,
        inverseRelationship: BELONGS_TO
      },
      topics: {
        relationship: ONE_TO_MANY
      }
    };
  }

  static get formConfig() {
    return {
      name: { type: "string" },
      description: { type: "textarea" },
      website: { type: "creating-select" },
      locations: { type: "creating-multiselect" },
      "contact-people": { type: "creating-multiselect" },
      comment: { type: "textarea" },
      priority: { type: "checkbox" },
      divisions: { type: "creating-multiselect" },
      "pending-reason": {
        type: "select", options: ["", "unstable", "on_hold", "foreign", ]
      },
      topics: { type: "filtering-multiselect" }
    };
  }

  static get requiredInputs() {
    return ["name", "website", "locations", ];
  }

  validation() {
    this.applyRequiredInputs();
  }
}

class OrgaUpdateFormObject extends OrgaCreateFormObject {
  static get properties() {
    return concat(
      OrgaCreateFormObject.properties,
      ["legal-form", "charitable", "umbrella-filters",
        "accredited-institution", "mailings", ]
    );
  }

  static get formConfig() {
    return merge(
      OrgaCreateFormObject.formConfig,
      {
        charitable: { type: "checkbox" },
        "legal-form": {
          type: "select",
          options: [
            "", "ev", "ggmbh", "gag", "foundation", "gug", "gmbh", "ag", "ug",
            "kfm", "gbr", "ohg", "kg", "eg", "sonstige", "state_entity",
          ]
        },
        "umbrella-filters": {
          type: "filtering-multiselect",
          resource: "filters",
          params: { filters: { type: "UmbrellaFilter" } }
        },
        "accredited-institution": { type: "checkbox" },
        mailings: {
          type: "select",
          options: ["disabled", "enabled", "force_disabled", ]
        }
      }
    );
  }

  // static get requiredInputs() {
  //   return concat(
  //     OrgaCreateFormObject.requiredInputs, ['legal-form']
  //   )
  // }

  static get submodels() {
    return concat(OrgaCreateFormObject.submodels, "umbrella-filters");
  }

  static get submodelConfig() {
    return merge(
      OrgaCreateFormObject.submodelConfig, {
        "umbrella-filters": {
          type: "filters",
          relationship: ONE_TO_MANY
        }
      }
    );
  }

  static get readOnlyProperties() {
    return ["aasm-state", ];
  }

  static additionalButtons(stateInstance) {
    const buttons = [];

    if (
      stateInstance &&
        ["approved", "all_done", ].includes(stateInstance["aasm-state"])

    // stateInstance['current-assignment']['receiver']...
    ) {
      buttons.push({
        className: "default",
        buttonLabel: "Speichern & Zuweisung schließen",
        actionName: "toSystem"
      });
    }
    return buttons;
  }
}

export {
  OrgaCreateFormObject, OrgaUpdateFormObject
};
