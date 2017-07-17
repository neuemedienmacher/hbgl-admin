export function setUi(key, value) {
  return { type: 'SET_UI', key, value }
}

export function setUiLoaded(bool, ...specifications) {
  const key = 'loaded-' + specifications.join('-')
  return { type: 'SET_UI', key, value: bool }
}
