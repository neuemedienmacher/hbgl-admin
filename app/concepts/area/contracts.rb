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
    validates :minlat, presence: true, format: /\d*(\,|\.){1}\d*/
    validates :maxlat, presence: true, format: /\d*(\,|\.){1}\d*/
    validates :minlong, presence: true, format: /\d*(\,|\.){1}\d*/
    validates :maxlong, presence: true, format: /\d*(\,|\.){1}\d*/
  end

  class Update < Create
    property :id, writeable: false
  end
end
