# frozen_string_literal: true

module TimeAllocation::Contracts
  class Update < Reform::Form
    property :id, writeable: false
    property :user_id
    property :week_number
    property :year
    property :desired_wa_hours
    property :actual_wa_hours
    property :actual_wa_comment

    validates :user_id, presence: true, numericality: true
    validates :week_number, presence: true, numericality: true
    validates :year, presence: true, numericality: true
    validates :desired_wa_hours, presence: true, numericality: true
    validates :actual_wa_hours, numericality: true, allow_blank: true
  end

  class Create < Update
    validates_uniqueness_of :user_id, scope: %i[week_number year]
    validates_uniqueness_of :week_number, scope: %i[user_id year]
    validates_uniqueness_of :year, scope: %i[week_number user_id]
  end
end
