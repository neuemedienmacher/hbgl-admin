# frozen_string_literal: true
module Filter::Contracts
  class Create < Reform::Form
    property :name
    property :identifier

    validates :name, presence: true
    validates_uniqueness_of :name
    validates :identifier, presence: true
    validates_uniqueness_of :identifier
  end
end
