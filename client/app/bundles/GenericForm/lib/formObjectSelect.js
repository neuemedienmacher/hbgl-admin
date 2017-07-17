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
  default:
    throw new Error(
      `Please provide a configuring FormObject for ${model} if you want to
      use the GenericForm bundle`
    )
  }
}
