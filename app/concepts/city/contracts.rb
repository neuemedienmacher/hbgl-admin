# frozen_string_literal: true

module City::Contracts
  class Create < Reform::Form
    property :name

    validates :name, presence: true
    validates_uniqueness_of :name
  end

  class Update < Create
    property :name

    validates :name, presence: true
    validates_uniqueness_of :name
  end
end
