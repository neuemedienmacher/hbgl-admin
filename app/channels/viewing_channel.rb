# frozen_string_literal: true

require 'redis-namespace'

class ViewingChannel < ApplicationCable::Channel
  module ViewingMemory
    class NoRedisDataError < StandardError
      def initialize(getter_name)
        super("Tried to find #{getter_name} data in redis, but it wasn't there")
      end
    end

    # rubocop:disable Style/GlobalVars
    # Reasoning: Redis is a singleton by design.
    REDISNS = Redis::Namespace.new('ViewingChannel', redis: $redis)
    # rubocop:enable Style/GlobalVars

    def self.add channel, view, user, tab_id
      REDISNS.sadd 'all_views', view
      REDISNS.hset 'tabs_users', tab_id, user
      REDISNS.hset 'tabs_channels', tab_id, channel
      REDISNS.hset 'tabs_views', tab_id, view
      REDISNS.rpush key(channel, view), tab_id
    end

    def self.get_current data_type, tab_id # get channel, user, or view
      result = REDISNS.hget "tabs_#{data_type}s", tab_id
      raise NoRedisDataError, data_type unless result
      result
    end

    def self.get_views channel
      view_hash = {}

      for_all_views do |view|
        view_hash[view] =
          REDISNS.lrange(key(channel, view), 0, -1).map do |tab_id|
            get_current :user, tab_id
          end
      end

      view_hash
    end

    def self.remove(channel, tab_id)
      view = get_current :view, tab_id
      REDISNS.lrem key(channel, view), 1, tab_id
      REDISNS.hdel 'tabs_users', tab_id
      REDISNS.hdel 'tabs_channels', tab_id
      REDISNS.hdel 'tabs_views', tab_id
    end

    at_exit do # clean up in case of a server abort / restart
      REDISNS.keys.each { |key| REDISNS.del(key) }
    end

    private_class_method

    def self.key(channel, view)
      "#{channel}:#{view}"
    end

    def self.for_all_views(&block)
      REDISNS.smembers('all_views').each(&block)
    end
  end

  def subscribed
    channel = channel_name(params)
    stream_from channel
    ViewingMemory.add(channel, params['view'], user, params['sessionID'])
    broadcast_views(channel)
  end

  def unsubscribed
    stop_all_streams
    previous_channel = ViewingMemory.get_current(:channel, params['sessionID'])

    ViewingMemory.remove(previous_channel, params['sessionID'])
    broadcast_views(previous_channel)
  end

  def change_view(data)
    previous_channel = ViewingMemory.get_current(:channel, data['sessionID'])
    next_channel = channel_name(data)

    ViewingMemory.remove(previous_channel, data['sessionID'])

    if previous_channel != next_channel
      stream_from next_channel
      broadcast_views(previous_channel)
    end

    ViewingMemory.add(next_channel, data['view'], user, data['sessionID'])
    broadcast_views(next_channel)
  end

  private

  def broadcast_views channel
    _, model, id = channel.split(':')
    ActionCable.server.broadcast(
      channel, model: model, id: id, views: ViewingMemory.get_views(channel)
    )
  end

  def channel_name hash
    ['viewing', hash['model'], hash['id'].to_s].join(':')
  end

  def user
    current_user.id
  end
end
