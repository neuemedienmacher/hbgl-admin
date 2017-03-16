# frozen_string_literal: true
# Monkeypatch clarat_base StatisticChart
require ClaratBase::Engine.root.join('app', 'models', 'statistic_chart')
require_relative 'offer'
require_relative 'organization'

class StatisticChart < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_everything,
                  against: [
                    :id, :title
                  ],
                  using: { tsearch: { prefix: true } }

  TARGET_MODELS = %w(Offer Organization SplitBase).freeze

  TARGET_FIELD_NAMES = {
    'Offer' => %w(aasm_state logic_version id?),
    'Organization' => %w(aasm_state id?),
    'SplitBase' => %w(id?)
  }.freeze

  TARGET_FIELD_VALUES = {
    'Offer' => {
      'aasm_state' => Offer.aasm.states.map(&:name),
      'logic_version' => (1..19).to_a,
      'id?' => [true]
    },
    'Organization' => {
      'aasm_state' => Organization.aasm.states.map(&:name),
      'id?' => [true]
    },
    'SplitBase' => {
      'id?' => [true]
    }
  }.freeze
end
