export default function routeForAction(action, model, id) {
  switch(action) {
  case 'edit':
    return `/${model}/${id}/edit`
  case 'show':
    return `/${model}/${id}`
  }
}
