# frozen_string_literal: true
module Area::Contracts
  class Create < Reform::Form
    property :name
    property :minlat
    property :maxlat
    property :minlong
    property :maxlong

    validates :name, presence: true
    validates_uniqueness_of :name
    validates :minlat, presence: true, numericality: {
      only_float: true,
      less_than: ->(area) { area.maxlat }
    }
    validates :maxlat, presence: true, numericality: {
      only_float: true,
      greater_than: ->(area) { area.minlat }
    }
    validates :minlong, presence: true, numericality: {
      only_float: true,
      less_than: ->(area) { area.maxlong }
    }
    validates :maxlong, presence: true, numericality: {
      only_float: true,
      greater_than: ->(area) { area.minlong }
    }
  end
end
