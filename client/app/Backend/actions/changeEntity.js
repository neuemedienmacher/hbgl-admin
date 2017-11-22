export default (model, id, changes) => ({
  type: 'CHANGE_ENTITY',
  model,
  id,
  changes
})
