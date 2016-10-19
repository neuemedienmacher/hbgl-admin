export default function routeForAction(action, model, id, assignable_model) {
  switch(action) {
  case 'edit':
    return `/${model}/${id}/edit`
  case 'show':
    return `/${model}/${id}`
  case 'edit_assignable':
    return `/${assignable_model}/${id}/edit`
  case 'assign_and_edit_assignable':
    return `api/v1/${model}/${id}/assign_and_edit_assignable`
  }
}
