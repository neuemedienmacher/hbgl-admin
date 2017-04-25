# frozen_string_literal: true
module Opening::Contracts
  class Create < Reform::Form
    property :day
    property :open
    property :close
    property :sort_value
    property :name

    validates :day, presence: true
    validates_uniqueness_of :day, scope: [:open, :close]
    validates_uniqueness_of :open, scope: [:day, :close]
    validates :open, presence: true, if: :close
    validates_uniqueness_of :close, scope: [:day, :open]
    validates :close, presence: true, if: :open

    validates :sort_value, presence: true
    validates :name, presence: true
  end
end
