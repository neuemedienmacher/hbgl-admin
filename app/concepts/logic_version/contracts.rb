# frozen_string_literal: true

module LogicVersion::Contracts
  class Create < Reform::Form
    property :name
    property :version

    validates :name, presence: true
    validates_uniqueness_of :name
    validates :version, presence: true
    validates_uniqueness_of :version
  end
end
