import GenericFormObject from "../lib/GenericFormObject";
import { ONE_TO_MANY, } from "../../../lib/constants";

export default class UserTeamFormObject extends GenericFormObject {
  static get model() {
    return "user-team";
  }

  static get type() {
    return "user-teams";
  }

  static get properties() {
    return [
      "name", "users", "observing-users",
    ];
  }

  static get submodels() {
    return [
      "users", "observing-users",
    ];
  }

  static get submodelConfig() {
    return {
      users: { relationship: ONE_TO_MANY, },
      "observing-users": { relationship: ONE_TO_MANY, },
    };
  }

  static get formConfig() {
    return {
      name: { type: "string", },
      users: { type: "filtering-multiselect", },
      "observing-users": { type: "filtering-multiselect", resource: "users", },
    };
  }

  static get requiredInputs() {
    return ["name", ];
  }

  validation() {
    this.applyRequiredInputs();
  }
}
