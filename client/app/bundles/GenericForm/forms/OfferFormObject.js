import GenericFormObject from "../lib/GenericFormObject";
import ContactPersonFormObject from "./ContactPersonFormObject";
import WebsiteFormObject from "./WebsiteFormObject";
import LocationFormObject from "./LocationFormObject";
import TargetAudienceFiltersOfferFormObject
  from "./TargetAudienceFiltersOfferFormObject";

import { ONE_TO_ONE, ONE_TO_MANY, BELONGS_TO } from "../../../lib/constants";

class OfferCreateFormObject extends GenericFormObject {
  static get model() {
    return "offer";
  }

  static get type() {
    return "offers";
  }

  static get properties() {
    return [
      "divisions", "name", "solution-category", "code-word",
      "description", "comment", "next-steps", "contact-people",
      "hide-contact-people", "encounter", "location", "area",
      "tags", "trait-filters", "language-filters",
      "target-audience-filters-offers", "openings", "opening-specification",
      "websites", "starts-at", "ends-at"
    ];
  }

  static get submodels() {
    return [
      "divisions", "next-steps", "contact-people", "location",
      "area", "tags", "solution-category", "trait-filters",
      "language-filters", "target-audience-filters-offers", "openings",
      "websites"
    ];
  }

  static get submodelConfig() {
    return {
      "divisions": {
        relationship: ONE_TO_MANY,
      },
      "next-steps": {
        relationship: ONE_TO_MANY,
      },
      "contact-people": {
        object: ContactPersonFormObject,
        relationship: ONE_TO_MANY,
      },
      location: {
        object: LocationFormObject,
        relationship: ONE_TO_ONE,
      },
      area: {
        relationship: ONE_TO_ONE,
      },
      tags: {
        relationship: ONE_TO_MANY,
      },
      "trait-filters": {
        relationship: ONE_TO_MANY,
      },
      "language-filters": {
        relationship: ONE_TO_MANY,
      },
      "target-audience-filters-offers": {
        object: TargetAudienceFiltersOfferFormObject,
        relationship: ONE_TO_MANY,
        inverseRelationship: BELONGS_TO
      },
      openings: {
        relationship: ONE_TO_MANY,
      },
      websites: {
        object: WebsiteFormObject,
        relationship: ONE_TO_MANY,
      },
      "solution-category": {
        relationship: ONE_TO_ONE,
      }
    };
  }

  static get formConfig() {
    return {
      divisions: { type: "filtering-multiselect" },
      name: { type: "string", addons: ["counter"] },
      description: { type: "textarea", addons: ["counter"] },
      comment: { type: "textarea" },
      "next-steps": { type: "filtering-multiselect", addons: ["counter"] },
      "contact-people": { type: "creating-multiselect" },
      "hide-contact-people": { type: "checkbox" },
      "code-word": { type: "string" },
      encounter: {
        type: "select", options: [
          "personal", "hotline", "email", "chat", "online-course", "forum",
          "portal"
        ]
      },
      location: { type: "creating-select" },
      area: { type: "filtering-select" },
      tags: { type: "filtering-multiselect" },
      "trait-filters": {
        type: "filtering-multiselect",
        resource: "filters",
        params: { filters: { type: "TraitFilter" } }
      },
      "language-filters": {
        type: "filtering-multiselect",
        resource: "filters",
        params: { filters: { type: "LanguageFilter" } }
      },
      "target-audience-filters-offers": {
        type: "creating-multiselect"
      },
      openings: {
        type: "filtering-multiselect",
        params: { sort_field: "sort_value", sort_direction: "ASC" }
      },
      "opening-specification": { type: "textarea" },
      "starts-at": { type: "date" },
      "ends-at": { type: "date" },
      websites: { type: "creating-multiselect" },
      "solution-category": { type: "filtering-select" },
    };
  }

  static get requiredInputs() {
    return [
      "solution-category", "divisions", "name",
      "target-audience-filters-offers", "language-filters", "description"
    ];
  }

  static get inputMaxLengths() {
    return {
      name: 80,
      description: 450,
      // NOTE: title and description max vals are only recommendations
      "next-steps": 10
    };
  }

  validation() {
    this.applyRequiredInputs();
    this.maybe("next-steps").filled({
      "max_size?": this.constructor.inputMaxLengths["next-steps"]
    });
  }
}

class OfferUpdateFormObject extends OfferCreateFormObject {
  // static get properties() {
  //   return concat(
  //     OfferCreateFormObject.properties,
  //     ["old-next-steps"]
  //   )
  // }
  //
  // static get formConfig() {
  //   return merge(
  //     OfferCreateFormObject.formConfig, {
  //       "old-next-steps": { type: "textarea" },
  //     }
  //   )
  // }

  static get readOnlyProperties() {
    return ["aasm-state"];
  }
}

export {
  OfferCreateFormObject, OfferUpdateFormObject
};
