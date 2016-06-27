export function selectUser(user_id) {
  return { type: 'SELECT_USER', user_id }
}

export function unselectUser(user_id) {
  return { type: 'UNSELECT_USER', user_id }
}
