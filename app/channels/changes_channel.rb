# frozen_string_literal: true

class ChangesChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'changes'
  end
end
