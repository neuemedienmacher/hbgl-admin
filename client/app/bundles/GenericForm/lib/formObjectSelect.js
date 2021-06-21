import UserTeamFormObject from "../forms/UserTeamFormObject";
import { DivisionCreateFormObject, DivisionUpdateFormObject }
  from "../forms/DivisionFormObject";
import { OrgaCreateFormObject, OrgaUpdateFormObject }
  from "../forms/OrganizationFormObject";
import WebsiteFormObject from "../forms/WebsiteFormObject";
import LocationFormObject from "../forms/LocationFormObject";
import CityFormObject from "../forms/CityFormObject";
import AreaFormObject from "../forms/AreaFormObject";
import FederalStateFormObject from "../forms/FederalStateFormObject";
import ContactPersonFormObject from "../forms/ContactPersonFormObject";
import EmailFormObject from "../forms/EmailFormObject";
import NextStepFormObject from "../forms/NextStepFormObject";
import { OfferCreateFormObject, OfferUpdateFormObject }
  from "../forms/OfferFormObject";
import OpeningFormObject from "../forms/OpeningFormObject";
import DefinitionFormObject from "../forms/DefinitionFormObject";
import TagFormObject from "../forms/TagFormObject";
import SolutionCategoryFormObject from "../forms/SolutionCategoryFormObject";
import TargetAudienceFiltersOfferFormObject
  from "../forms/TargetAudienceFiltersOfferFormObject";

const modelFormObjectMap = (editing) => ({
  "user-teams": UserTeamFormObject,
  "divisions": editing ? DivisionUpdateFormObject : DivisionCreateFormObject,
  "organizations": editing ? OrgaUpdateFormObject : OrgaCreateFormObject,
  "websites": WebsiteFormObject,
  "locations": LocationFormObject,
  "cities": CityFormObject,
  "areas": AreaFormObject,
  "federal-states": FederalStateFormObject,
  "contact-people": ContactPersonFormObject,
  "emails": EmailFormObject,
  "next-steps": NextStepFormObject,
  "offers": editing ? OfferUpdateFormObject : OfferCreateFormObject,
  "openings": OpeningFormObject,
  "tags": TagFormObject,
  "definitions": DefinitionFormObject,
  "solution-categories": SolutionCategoryFormObject,
  "target-audience-filters-offers": TargetAudienceFiltersOfferFormObject,
});


export default function formObjectSelect(model, editing) {
  const obj = modelFormObjectMap(editing)[model];
  if (obj) return obj;
  throw new Error(
  `Please provide a configuring FormObject for ${model} if you want to
   use the GenericForm bundle`
  );
}
