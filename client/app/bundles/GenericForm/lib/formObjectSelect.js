import UserTeamFormObject from '../forms/UserTeamFormObject'
import DivisionFormObject from '../forms/DivisionFormObject'
import OrganizationFormObject from '../forms/OrganizationFormObject'

export default function formObjectSelect(model) {
  switch(model) {
  case 'user_teams':
    return UserTeamFormObject
  case 'divisions':
    return DivisionFormObject
  case 'organizations':
    return OrganizationFormObject
  default:
    throw new Error(
      `Please provide a configuring FormObject for ${model} if you want to
      use the GenericForm bundle`
    )
  }
}
