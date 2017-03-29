# frozen_string_literal: true
module TimeAllocation::Contracts
  class Update < Reform::Form
    property :user_id
    property :week_number
    property :year
    property :desired_wa_hours
    property :actual_wa_hours

    validates :user_id, presence: true, numericality: true
    validates :week_number, presence: true, numericality: true
    validates :year, presence: true, numericality: true
    validates :desired_wa_hours, presence: true, numericality: true
    validates :actual_wa_hours, numericality: true, allow_blank: true
  end

  class Create < Update
    validates_uniqueness_of :user_id, scope: [:week_number, :year]
    validates_uniqueness_of :week_number, scope: [:user_id, :year]
    validates_uniqueness_of :year, scope: [:week_number, :user_id]
  end
end
