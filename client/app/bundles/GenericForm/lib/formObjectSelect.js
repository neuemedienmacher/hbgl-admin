import UserTeamFormObject from '../forms/UserTeamFormObject'
import DivisionFormObject from '../forms/DivisionFormObject'
import { OrgaCreateFormObject, OrgaUpdateFormObject }
  from '../forms/OrganizationFormObject'
import WebsiteFormObject from '../forms/WebsiteFormObject'
import LocationFormObject from '../forms/LocationFormObject'
import CityFormObject from '../forms/CityFormObject'
import FederalStateFormObject from '../forms/FederalStateFormObject'
import ContactPersonFormObject from '../forms/ContactPersonFormObject'
import EmailFormObject from '../forms/EmailFormObject'
import { OfferCreateFormObject, OfferUpdateFormObject }
  from '../forms/OfferFormObject'
import OpeningFormObject from '../forms/OpeningFormObject'
import DefinitionFormObject from '../forms/DefinitionFormObject'
import TagFormObject from '../forms/TagFormObject'
import SolutionCategoryFormObject from '../forms/SolutionCategoryFormObject'
import SplitBaseFormObject from '../forms/SplitBaseFormObject'
import TargetAudienceFiltersOfferFormObject
  from '../forms/TargetAudienceFiltersOfferFormObject'

export default function formObjectSelect(model, editing) {
  switch(model) {
  case 'user-teams':
    return UserTeamFormObject
  case 'divisions':
    return DivisionFormObject
  case 'organizations':
    return editing ? OrgaUpdateFormObject : OrgaCreateFormObject
  case 'websites':
    return WebsiteFormObject
  case 'locations':
    return LocationFormObject
  case 'cities':
    return CityFormObject
  case 'federal-states':
    return FederalStateFormObject
  case 'contact-people':
    return ContactPersonFormObject
  case 'emails':
    return EmailFormObject
  case 'offers':
    return editing ? OfferUpdateFormObject : OfferCreateFormObject
  case 'openings':
    return OpeningFormObject
  case 'tags':
    return TagFormObject
  case 'definitions':
    return DefinitionFormObject
  case 'solution-categories':
    return SolutionCategoryFormObject
  case 'split-bases':
    return SplitBaseFormObject
  case 'target-audience-filters-offers':
    return TargetAudienceFiltersOfferFormObject
  default:
    throw new Error(
      `Please provide a configuring FormObject for ${model} if you want to
      use the GenericForm bundle`
    )
  }
}
