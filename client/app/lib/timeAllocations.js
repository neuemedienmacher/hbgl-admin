import merge from 'lodash/merge'

// Get the TimeAllocation for the given user at given point in time,
// if none is found the most recent historical value will be returned instead.
// @return [Array] - Index 0: Data existed for given time?
//                   Index 1: Historical data existed?
//                   Index 2: Time Allocation object
export function getAllocationForWeekAndUser(
  time_allocations, week_number, year, user_id
) {
  const allocationsForUser =
    time_allocations.filter(ta => ta.user_id == user_id)

  const existingAllocationForGivenTime = allocationsForUser.filter( ta =>
    ta.week_number == week_number && ta.year == year
  )[0]
  if (existingAllocationForGivenTime) {
    return [true, false, existingAllocationForGivenTime]
  }

  const earlierAllocations = allocationsForUser.filter( ta =>
    ta.year < year || (ta.year == year && ta.week_number <= week_number)
  )
  let closestEarlierAllocation = earlierAllocations.sort( (a, b) => {
    if (a.year > b.year || (a.year == b.year && a.week_number > b.week_number)) {
      return -1
    } else {
      return 1
    }
  })[0]

  if (closestEarlierAllocation) {
    return [false, true, merge({}, closestEarlierAllocation, {
      id: null, actual_wa_hours: null
    })]
  }

  return [false, false, {
    desired_wa_hours: 0, actual_wa_hours: null, year, week_number, user_id
  }]
}
