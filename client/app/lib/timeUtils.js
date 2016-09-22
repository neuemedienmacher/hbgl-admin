export function getTimePointsBetween(start, end, step = 'day') {
	let now = start.startOf(step)
  let dates = []

  while (now.isBefore(end)) {
    dates.push(now.clone())
    now.add(1, step)
  }
  return dates
}
