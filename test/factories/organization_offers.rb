# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :organization_offer do
    offer
    organization do
      FactoryBot.create :organization, :approved
    end
  end
end
