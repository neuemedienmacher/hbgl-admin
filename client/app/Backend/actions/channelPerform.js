export default (channelName, actionName, data) => ({
  type: 'CHANNEL_PERFORM', channelName, actionName, data
})
