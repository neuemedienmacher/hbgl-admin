import { normalize, Schema, arrayOf } from 'normalizr'

const Schemas = new function() {
  const defaultOptions = { idAttribute: 'id' }

  this.user = new Schema('users', defaultOptions)
  this.users = arrayOf(this.user)
  this.current_user = this.user

  this.user_team = new Schema('user_teams', defaultOptions)
  this.user_teams = arrayOf(this.user_team)

  this.productivity_goal = new Schema('productivity_goals', defaultOptions)
  this.productivity_goals = arrayOf(this.productivity_goal)

  this.statistic = new Schema('statistics', defaultOptions)
  this.statistics = arrayOf(this.statistic)

  this.time_allocation = new Schema('time_allocations', defaultOptions)
  this.time_allocations = arrayOf(this.time_allocation)

  // Definitions //

  // this.pledge.define({
  //   initiator: this.user,
  //   tags: this.tags,
  // })
}

export default function normalized(schemaName, data) {
  if (!Schemas[schemaName]) {
    console.error(`No normalization schema for ${schemaName}`)
  }
  return normalize(data, Schemas[schemaName])
}

module.exports = normalized
