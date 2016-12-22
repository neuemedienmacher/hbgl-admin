export function routeForAction(
  action, model, id, assignable_model, assignable_id
) {
  switch(action) {
  case 'edit':
    return `/${model}/${id}/edit`
  case 'show':
    return `/${model}/${id}`
  case 'edit_assignable':
    return `/${assignable_model}/${assignable_id}/edit`
  }
}
