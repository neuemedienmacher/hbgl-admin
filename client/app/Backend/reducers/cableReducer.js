import merge from 'lodash/merge'
import forEach from 'lodash/forEach'

export const initialState = {
  channels: {},
  live: {
    viewing: {}
  }
}

export default function cableReducer(state = initialState, action) {
  let newState = merge({}, state)

  switch (action.type) {
    case 'ADD_CHANNEL':
      if (newState.channels[action.params.channel]) return newState
      newState.channels[action.params.channel] =
        Cable.subscriptions.create(action.params, action.options)
      return newState

    case 'REMOVE_CHANNEL':
      Cable.subscriptions.remove(state.channels[action.channelName])
      newState.channels[action.channelName] = null
      return newState

    case 'CHANNEL_PERFORM':
      state.channels[action.channelName].perform(action.actionName, action.data)

    case 'CHANGE_VIEWING':
      newState.live.viewing[action.model] =
        newState.live.viewing[action.model] || {}
      newState.live.viewing[action.model][action.id] = action.data

      return newState

    default:
      return state
  }
}
