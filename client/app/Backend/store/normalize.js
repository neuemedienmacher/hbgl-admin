import { normalize, Schema, arrayOf } from 'normalizr'

const Schemas = new function() {
  const defaultOptions = { idAttribute: 'id' }

  this.user = new Schema('users', defaultOptions)
  this.users = arrayOf(this.user)
  this['current-user'] = this.user

  this['user-team'] = new Schema('user-teams', defaultOptions)
  this['user-teams'] = arrayOf(this['user-team'])

  this.filter = new Schema('filters', defaultOptions)
  this.filters = arrayOf(this.filter)

  this.statistic_chart = new Schema('statistic_charts', defaultOptions)
  this.statistic_charts = arrayOf(this.statistic_chart)

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
