# frozen_string_literal: true
FactoryGirl.define do
  factory :section do
    transient do
      _random do
        [%w(family Family), %w(refugees Refugees)].sample
      end
    end
    identifier { _random[0] }
    name { _random[1] }

    trait :family do
      identifier 'family'
      name 'Family'
    end

    trait :refugees do
      identifier 'refugees'
      name 'Refugees'
    end
  end
end
