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

export function assignableRouteForAction(action, model, id) {
  switch(action) {
  case 'assign_to_current_user':
    return `/api/v1/${model}/${id}`
  case 'retrieve_assignment':
    return `/api/v1/${model}/`
  case 'assign_someone_else':
    return `/api/v1/${model}/`
  case 'assign_to_system':
    return `/api/v1/${model}/`
  }
}
