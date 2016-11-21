require 'ffaker'

FactoryGirl.define do
  factory :assignment do
    message { FFaker::Lorem.sentence }
    creator { User.first }
    creator_team { UserTeam.first }
    reciever { User.last }
    reciever_team { UserTeam.first }
    # translations are the first model for the assignments, so we use them for tests
    assignable { FactoryGirl.create :offer_translation }
    assignable_type 'OfferTranslation'

    trait :with_field do
      assignable_field_type 'id' # every model has an ID field
    end

    trait :with_parent do
      parent { FactoryGirl.create :assignment }
    end
  end
end
